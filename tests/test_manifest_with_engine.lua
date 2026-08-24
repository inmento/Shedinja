local root = arg[1] or "."
package.path = "/tmp/gen1recomp-current-crystal/?.lua;/tmp/gen1recomp-current-crystal/?/init.lua;" .. package.path

local Manifest = require("src.mods.Manifest")
local ModTargets = require("src.mods.ModTargets")
local raw = {
  id = "shedinja",
  name = "Shedinja",
  version = "0.4.0",
  github = "inmento/Shedinja",
  api = 2,
  entry = "main.lua",
  profile = "overhaul",
  category = "GAMEPLAY",
  permissions = { "engine_internals" },
  games = { "gen1", "gen2" },
  optional_dependencies = {
    {
      id = "CRYSTAL_251",
      range = ">=0.11.3 <1.0.0",
      games = { "gen1" },
      github = "Deftones565/gen1recomp-mod-crystal-251",
    },
  },
  game_version = ">=0.2.24 <1.0.0",
  incompatible = { "Kanto-Reforged" },
  affects_link = true,
  description = "Standalone Shedinja expansion for Red/Blue/Yellow, Gold, Silver, and Crystal.",
}
local manifest = Manifest.validate(raw, root)
assert(manifest.id == "shedinja")
assert(manifest.version == "0.4.0", "manifest must carry the native Crystal release")
assert(manifest.github == "inmento/Shedinja",
  "manifest must declare the repository used by launcher updates")
assert(manifest.gen2compat == true
  and ModTargets.supports(manifest, "gold", 2)
  and ModTargets.supports(manifest, "silver", 2)
  and ModTargets.supports(manifest, "crystal", 2),
  "manifest must declare native Gen 2 compatibility including Crystal")
assert(#manifest.conflicts == 1 and manifest.conflicts[1] == "Kanto-Reforged",
  "Crystal 251 must no longer be a core Shedinja conflict")
assert(#manifest.optionalSpecs == 1,
  "Standalone Shedinja must retain only the separately scoped Crystal 251 ordering relation")
local crystal = manifest.optionalSpecs[1]
assert(crystal and crystal.github == "Deftones565/gen1recomp-mod-crystal-251"
  and ModTargets.specApplies(crystal, "red", 1)
  and not ModTargets.specApplies(crystal, "gold", 2)
  and not ModTargets.specApplies(crystal, "crystal", 2),
  "Crystal 251 relationship must remain Gen 1-scoped and repository-hinted")
print("Shedinja v0.2.24 engine manifest test passed")
