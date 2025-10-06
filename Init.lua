local addonName, addonTable = ...
local Metadata = addonTable.Metadata
local Dialog = addonTable.Dialog

local function InitAddonCompartmentFunc()
  local addonCompartmentFuncName = addonName .. "_AddonCompartmentFunc"
  _G[addonCompartmentFuncName] = function() Dialog:Toggle() end
end

local function InitSlashCommands()
  local addonNameUpperCase = addonName:upper()
  local commands = {
    addonName,
    Metadata.Initials
  }

  for index, command in ipairs(commands) do
    local name = "SLASH_" .. addonNameUpperCase .. "_TOGGLE_DIALOG" .. index
    _G[name] = "/" .. command
  end

  SlashCmdList[addonNameUpperCase .. "_TOGGLE_DIALOG"] = function()
    Dialog:Toggle()
  end
end

Dialog:Init()
InitAddonCompartmentFunc()
InitSlashCommands()
