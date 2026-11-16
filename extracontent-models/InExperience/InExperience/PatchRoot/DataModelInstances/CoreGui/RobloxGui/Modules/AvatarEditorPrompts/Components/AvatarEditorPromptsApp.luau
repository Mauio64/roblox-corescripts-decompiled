local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local Connection = require(script.Parent.Connection)

local Prompts = script.Parent.Prompts
local AllowInventoryReadAccessPrompt = require(Prompts.AllowInventoryReadAccessPrompt)
local SaveAvatarPrompt = require(Prompts.SaveAvatarPrompt)
local SaveAvatarTimeoutPrompt = require(Prompts.SaveAvatarTimeoutPrompt)
local CreateOutfitPrompt = require(Prompts.CreateOutfitPrompt)
local EnterOutfitNamePrompt = require(Prompts.EnterOutfitNamePrompt)
local SetFavoritePrompt = require(Prompts.SetFavoritePrompt)
local DeleteOutfitPrompt = require(Prompts.DeleteOutfitPrompt)
local RenameOutfitPrompt = require(Prompts.RenameOutfitPrompt)
local UpdateOutfitPrompt = require(Prompts.UpdateOutfitPrompt)

local LocalPlayer = Players.LocalPlayer

local parent = script.Parent.Parent

local PromptType = require(parent.PromptType)

local ScreenSizeUpdated = require(parent.Actions.ScreenSizeUpdated)

local set = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}

local v = {
	[PromptType.AllowInventoryReadAccess] = AllowInventoryReadAccessPrompt,
	[PromptType.SaveAvatar] = SaveAvatarPrompt,
	[PromptType.CreateOutfit] = CreateOutfitPrompt,
	[PromptType.EnterOutfitName] = EnterOutfitNamePrompt,
	[PromptType.SetFavorite] = SetFavoritePrompt,
	[PromptType.DeleteOutfit] = DeleteOutfitPrompt,
	[PromptType.RenameOutfit] = RenameOutfitPrompt,
	[PromptType.UpdateOutfit] = UpdateOutfitPrompt,
	[PromptType.SaveAvatarTimeout] = SaveAvatarTimeoutPrompt
}

local extended = Roact.PureComponent:extend("AvatarEditorPromptsApp")

extended.validateProps = t.strictInterface({
	promptType = t.optional(t.userdata),
	screenSizeUpdated = t.callback
})

function extended:init()
	self:setState({
		isGamepad = set[UserInputService:GetLastInputType()] or false
	})

	function self.absoluteSizeChanged(p)
		self.props.screenSizeUpdated(p.AbsoluteSize)
	end

	self.focusController = RoactGamepad.createFocusController()

	self.selectedCoreGuiObject = nil
	self.selectedGuiObject = nil
end

function extended.render(props)
	local prompt = nil

	if props.props.promptType then
		local v2 = v[props.props.promptType]

		if v2 then
			prompt = Roact.createElement(v2)
		else
			error("Unexpected prompt type!")
		end
	end

	if prompt == nil then
		return nil
	end

	return (Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		DisplayOrder = -1,
		[Roact.Change.AbsoluteSize] = props.absoluteSizeChanged
	}, {
		Connection = Roact.createElement(Connection),
		LastInputTypeConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p)
				props:setState({
					isGamepad = set[p] or false
				})
			end
		}) or nil,
		PromptFrame = Roact.createElement(
			RoactGamepad.Focusable.Frame,
			{
				focusController = props.focusController,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			},
			{ Prompt = prompt }
		) or nil
	}))
end

function extended:revertSelectedGuiObject()
	local playerGui = LocalPlayer and LocalPlayer:FindFirstChildWhichIsA("PlayerGui")

	if self.selectedCoreGuiObject and self.selectedCoreGuiObject:IsDescendantOf(CoreGui) then
		GuiService.SelectedCoreObject = self.selectedCoreGuiObject
	else
		if self.selectedGuiObject and self.selectedGuiObject:IsDescendantOf(playerGui) then
			GuiService.SelectedObject = self.selectedGuiObject
		end

		GuiService.SelectedCoreObject = nil
	end

	self.selectedCoreGuiObject = nil
	self.selectedGuiObject = nil
end

function extended:didUpdate(p, p2)
	local v2 = self.state.isGamepad and self.props.promptType ~= nil

	if v2 ~= (p2.isGamepad and p.promptType ~= nil) then
		if v2 then
			self.selectedCoreGuiObject = GuiService.SelectedCoreObject
			self.selectedGuiObject = GuiService.SelectedObject
			GuiService.SelectedObject = nil
			self.focusController.captureFocus()
		else
			self.focusController.releaseFocus()

			if self.state.isGamepad then
				self:revertSelectedGuiObject()
			end
		end
	end
end

function extended:willUnmount()
	if self.state.isGamepad then
		self:revertSelectedGuiObject()
	end
end

local function mapStateToProps(p)
	return { promptType = p.promptInfo.promptType }
end

local function mapDispatchToProps(callback)
	return {
		screenSizeUpdated = function(p)
			return callback(ScreenSizeUpdated(p))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
