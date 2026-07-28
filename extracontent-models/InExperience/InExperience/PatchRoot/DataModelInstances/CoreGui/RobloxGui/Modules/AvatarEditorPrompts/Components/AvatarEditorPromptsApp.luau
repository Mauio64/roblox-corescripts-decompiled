local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
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
local ParentParent = script.Parent.Parent
local PromptType = require(ParentParent.PromptType)
local ScreenSizeUpdated = require(ParentParent.Actions.ScreenSizeUpdated)
local t1 = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}
local t2 = {
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
local v28 = Roact.PureComponent:extend("AvatarEditorPromptsApp")

v28.validateProps = t.strictInterface({
	promptType = t.optional(t.userdata),
	screenSizeUpdated = t.callback
})

function v28.init(p1) -- line: 70
	-- upvalues: t1 (copy), UserInputService (copy), RoactGamepad (copy)
	p1:setState({
		isGamepad = t1[UserInputService:GetLastInputType()] or false
	})

	function p1.absoluteSizeChanged(p2) -- line: 75
		-- upvalues: p1 (copy)
		p1.props.screenSizeUpdated(p2.AbsoluteSize)
	end

	p1.focusController = RoactGamepad.createFocusController()
	p1.selectedCoreGuiObject = nil
	p1.selectedGuiObject = nil
end
function v28.render(p3) -- line: 85
	-- upvalues: t2 (copy), Roact (copy), Connection (copy), ExternalEventConnection (copy), UserInputService (copy), t1 (copy), RoactGamepad (copy)
	local v33 = nil

	if p3.props.promptType then
		local v34 = t2[p3.props.promptType]

		if v34 then
			v33 = Roact.createElement(v34)
		else
			error("Unexpected prompt type!")
		end
	end

	if v33 == nil then
		return nil
	end

	return (Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		DisplayOrder = -1,
		[Roact.Change.AbsoluteSize] = p3.absoluteSizeChanged
	}, {
		Connection = Roact.createElement(Connection),
		LastInputTypeConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p4) -- line: 110
				-- upvalues: p3 (copy), t1 (copy)
				p3:setState({
					isGamepad = t1[p4] or false
				})
			end
		}) or nil,
		PromptFrame = Roact.createElement(RoactGamepad.Focusable.Frame, {
			BackgroundTransparency = 1,
			focusController = p3.focusController,
			Size = UDim2.fromScale(1, 1)
		}, {
			Prompt = v33
		}) or nil
	}))
end
function v28.revertSelectedGuiObject(p5) -- line: 128
	-- upvalues: LocalPlayer (copy), CoreGui (copy), GuiService (copy)
	local v36 = LocalPlayer and LocalPlayer:FindFirstChildWhichIsA("PlayerGui")

	if p5.selectedCoreGuiObject and p5.selectedCoreGuiObject:IsDescendantOf(CoreGui) then
		GuiService.SelectedCoreObject = p5.selectedCoreGuiObject
	elseif p5.selectedGuiObject and p5.selectedGuiObject:IsDescendantOf(v36) then
		GuiService.SelectedObject = p5.selectedGuiObject
		GuiService.SelectedCoreObject = nil
	else
		GuiService.SelectedCoreObject = nil
	end

	p5.selectedCoreGuiObject = nil
	p5.selectedGuiObject = nil
end
function v28.didUpdate(p6, p7, p8) -- line: 144
	-- upvalues: GuiService (copy)
	local v40 = p6.state.isGamepad and p6.props.promptType ~= nil

	if v40 ~= (p8.isGamepad and p7.promptType ~= nil) then
		if v40 then
			p6.selectedCoreGuiObject = GuiService.SelectedCoreObject
			p6.selectedGuiObject = GuiService.SelectedObject
			GuiService.SelectedObject = nil
			p6.focusController.captureFocus()

			return
		end

		p6.focusController.releaseFocus()

		if p6.state.isGamepad then
			p6:revertSelectedGuiObject()
		end
	end
end
function v28.willUnmount(p9) -- line: 163
	if p9.state.isGamepad then
		p9:revertSelectedGuiObject()
	end
end

local function mapStateToProps(p10) -- line: 169
	return {
		promptType = p10.promptInfo.promptType
	}
end
local function mapDispatchToProps(p11) -- line: 175
	-- upvalues: ScreenSizeUpdated (copy)
	return {
		screenSizeUpdated = function(p12) -- line: 177
			-- upvalues: p11 (copy), ScreenSizeUpdated (copy)
			return p11(ScreenSizeUpdated(p12))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v28)
