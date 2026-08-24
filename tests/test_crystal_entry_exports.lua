local root = arg[1] or "."

package.preload["src.core.GameVersion"] = function()
  return {
    get = function() return "crystal" end,
    generation = function(id)
      assert(id == "crystal", "Shedinja must classify the active Crystal version")
      return 2
    end,
    engine = function(id)
      assert(id == "crystal", "Shedinja must preserve Crystal engine identity")
      return "crystal"
    end,
  }
end

local installed = false
package.preload["mods.shedinja.gold"] = function()
  return {
    install = function(mod, speciesId, itemId, teraItemId, balloonItemId, config)
      installed = true
      assert(speciesId == "SHEDINJA")
      assert(itemId == "WONDER_GUARD")
      assert(teraItemId == "ELEC_TERA_ORB")
      assert(balloonItemId == "AIR_BALLOON")
      assert(config and config.enableElmReward == false,
        "native Crystal must conservatively disable only the unverified Elm reward trigger")
      return {
        SHEDINJA = speciesId,
        WONDER_GUARD = itemId,
        marker = "crystal-entry-exports",
      }
    end,
  }
end

local mod = { exports = {} }
local init = assert(dofile(root .. "/main.lua"), "Shedinja entry module did not return an initializer")
local returned = assert(init(mod), "Crystal Shedinja initializer failed")
assert(installed, "Crystal must invoke the shared Gen 2 installer")
assert(returned == mod.exports, "Crystal entry must return the API 2 export table")
assert(mod.exports.SHEDINJA == "SHEDINJA" and mod.exports.WONDER_GUARD == "WONDER_GUARD",
  "Crystal core exports must publish the bridge-facing Shedinja handles")
assert(mod.exports.marker == "crystal-entry-exports",
  "Crystal installer exports must be copied into the API 2 export table")

print("Crystal Shedinja entry export harness: valid")
