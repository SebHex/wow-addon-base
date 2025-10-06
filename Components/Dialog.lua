local addonName, addonTable = ...
local Metadata = addonTable.Metadata

local dialogName = addonName .. "Dialog"
local dialogTemplates = "PortraitFrameTemplate"
local dialog = CreateFrame("Frame", dialogName, UIParent, dialogTemplates)

function dialog:ApplyFrameProps()
  self:SetSize(809, 883)
  self:SetPoint("TOP", 0, -41)
  self:SetMovable(true)
  self:EnableMouse(true)
  self:SetToplevel(true)
  self:SetResizable(true)
  self:SetClampedToScreen(true)
  self:Hide()
end

function dialog:CreateFrameElements()
  self.TitleBar = CreateFrame("Frame", nil, self, "PanelDragBarTemplate")
  self.TitleBar:SetSize(self:GetWidth(), 32)
  self.TitleBar:SetPoint("TOPLEFT")
  self.TitleBar:SetPoint("TOPRIGHT")
  self.ResizeButton = CreateFrame("Button", nil, self, "PanelResizeButtonTemplate")
  self.ResizeButton:SetPoint("BOTTOMRIGHT", -4, 4)
end

function dialog:SetPortraitBackground()
  local portrait = self:GetPortrait()
  local portraitContainer = self.PortraitContainer
  portrait.Background = portraitContainer:CreateTexture(addonName .. "DialogPortraitBackground")
  portrait.Background:SetSize(portrait:GetSize())
  portrait.Background:SetPoint(portrait:GetPoint())
  portrait.Background:SetAtlas("CircleMaskScalable")
  portrait.Background:SetVertexColor(0, 0, 0, 1)
end

function dialog:EnableResizing()
  local minPanelWidth = 400
  local minPanelHeight = 400
  self.ResizeButton:Init(self, minPanelWidth, minPanelHeight)
end

function dialog:OnShow()
  UIFrameFadeIn(self, 0.075, 0, 1)
  DoEmote("READ", nil, true)
  PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
  PlaySound(SOUNDKIT.UI_CLASS_TALENT_OPEN_WINDOW)
end

function dialog:OnHide()
  CancelEmote()
  PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE)
  PlaySound(SOUNDKIT.UI_CLASS_TALENT_CLOSE_WINDOW)
end

function dialog:Init()
  self:ApplyFrameProps()
  self:CreateFrameElements()
  self:EnableResizing()
  self:SetTitle(Metadata.Title)
  self:SetPortraitTextureRaw(Metadata.IconTexture)
  self:SetPortraitBackground()

  FrameUtil.ReflectStandardScriptHandlers(self)

  RegisterUIPanel(self, {
    pushable = 1,
    centerXOffset = 0,
    allowOtherPanels = 1,
    area = "centerOrLeft",
    whileDead = true
  })
end

addonTable.Dialog = dialog
