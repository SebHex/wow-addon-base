local addonName, addonTable = ...
local Metadata = addonTable.Metadata
local Libs = addonTable.Libs
local AceAddon = Libs.AceAddon
local AceDB = Libs.AceDB
local LibDataBroker = Libs.LibDataBroker
local LibDBIcon = Libs.LibDBIcon
local AceDBOptions = Libs.AceDBOptions
local AceConfig = Libs.AceConfig
local AceConfigDialog = Libs.AceConfigDialog

local Utils = {}
addonTable.Utils = Utils

--[[
  Print a message to the chat frame. The message is formatted as a warning.
]]
function Utils:PrintWarning(message)
  local warningIcon = CreateAtlasMarkup("services-icon-warning", 16, 16)
  print(warningIcon, "|cfff8e928" .. message .. "|r")
end

--[[
  Attempt to load an addon. If it fails, a warning is printed to the chat frame.
  Returns true if the addon was loaded, false otherwise.
]]
function Utils:LoadAddon(name)
  if (not IsAddOnLoaded(name)) then
    local loaded, reason = LoadAddOn(name)

    if (not loaded) then
      Utils:PrintWarning(format(ADDON_LOAD_FAILED, name, _G["ADDON_" .. reason]))
      return false
    else
      return true
    end
  end

  return true
end

--[[
  Log data to the ViragDevTool addon.
  Recommended for debugging and addon development.

  See https://github.com/brittyazel/ViragDevTool
]]
function Utils:Log(data, name)
  if (not Utils:LoadAddon("ViragDevTool")) then
    return
  end

  name = name or tostring(data)

  if (ViragDevToolFrame) then
    ViragDevTool:AddData(data, name)
  else
    ViragDevTool.list:AddNode(data, name)
  end
end

--[[
  Toggle the ViragDevTool dialog to see logs.

  See https://github.com/brittyazel/ViragDevTool
]]
function Utils:ToggleLogsDialog()
  if (Utils:LoadAddon("ViragDevTool")) then
    ViragDevTool:ToggleUI()
  end
end

--[[
  Create an addon using Ace3.

  See https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0
]]
function Utils:CreateAddon(name)
  return AceAddon:NewAddon(name, "AceConsole-3.0")
end

--[[
  Create a db using Ace3.

  See https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
]]
function Utils:CreateDB(addon, name, defaultOptions)
  local db = AceDB:New(name, defaultOptions, true)
  db.RegisterCallback(addon, "OnProfileChanged", "RefreshConfig")
  db.RegisterCallback(addon, "OnProfileCopied", "RefreshConfig")
  db.RegisterCallback(addon, "OnProfileReset", "RefreshConfig")

  return db
end

--[[
  Create a minimap icon using LibDataBroker and LibDBIcon.
]]
function Utils:CreateMinimapIcon(options)
  local minimapIconData = LibDataBroker:NewDataObject(addonName, options)
  LibDBIcon:Register(addonName, minimapIconData, addonTable.db.profile.minimap)

  return LibDBIcon
end

--[[
  Create a config dialog using Ace3.
]]
function Utils:CreateConfigDialog(options, width, height)
  options.args.profile = AceDBOptions:GetOptionsTable(addonTable.db)
  AceConfig:RegisterOptionsTable(addonName, options)
  AceConfigDialog:AddToBlizOptions(addonName, Metadata.Title)
  AceConfigDialog:SetDefaultSize(addonName, width, height)

  return AceConfigDialog
end

--[[
  Set the minimap icon to shown or hidden.
]]
function Utils:SetMinimapIconShown(shown)
  if (shown) then
    LibDBIcon:Show(addonName)
  else
    LibDBIcon:Hide(addonName)
  end
end

local configDialogStatusText = format("|cff808080Version: %s • Author: %s|r", Metadata.Version, Metadata.Author)

--[[
  Open the config dialog.
]]
function Utils:OpenConfigDialog()
  if (AceConfigDialog.OpenFrames[addonName]) then
    return
  end

  AceConfigDialog:Open(addonName)
  AceConfigDialog.OpenFrames[addonName]:SetStatusText(configDialogStatusText)
end

--[[
  Close the config dialog.
]]
function Utils:CloseConfigDialog()
  AceConfigDialog:Close(addonName)
end

--[[
  Toggle the config dialog.
]]
function Utils:ToggleConfigDialog()
  local isOpen = AceConfigDialog.OpenFrames[addonName]

  if (isOpen) then
    Utils:CloseConfigDialog()
  else
    Utils:OpenConfigDialog()
  end
end
