import torch

import pyro
import pyro.distributions as dist
from pyro.infer.mcmc import MCMC, NUTS
from pyro.infer import EmpiricalMarginal

class RSASpeaker(dist.Distribution):
  
  def __init__(self, mu, phi):
    self.mu = mu
    self.phi = phi
    self.tmp = (self.phi - self.mu)
  
  def sample(self, *args, **kwargs):
    return torch.tensor(1.)
  
  def log_prob(self, x):
    shp = x.shape
    ret = torch.ones(shp) * -.1
    tmp = self.tmp * (x - 0.5)
    ret[tmp > 0] = -999999999.
    return ret




def model(utt, phi):
  a = pyro.sample("a", dist.Uniform(.1, 20.))
  b = pyro.sample("b", dist.Uniform(.1, 20.))
  
  mu = pyro.sample("mu", dist.Beta(a,b))
  nu = pyro.sample("nu", dist.LogNormal(2,0.5))
  
  a2 = mu * (nu + 1)
  b2 = (1-mu) * (nu + 1)
  
  with pyro.plate("data"):
         pyro.sample("obs", RSASpeaker(mu, phi), obs=utt)


utt = torch.ones(200)
utt[50:200] = 0

phi = torch.rand(50) * .3
phi2 = torch.rand(150) * 0.6 + .4

phi = torch.cat([phi, phi2])


nuts_kernel = NUTS(model, jit_compile=True, adapt_step_size=True)

hmc_posterior = MCMC(nuts_kernel, num_samples=100, warmup_steps=200) \
    .run(utt, phi)

print(EmpiricalMarginal(hmc_posterior, "mu")._get_samples_and_weights()[0])
print(hmc_posterior.marginal('mu').empirical['mu'].mean)
