local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Actions = scriptParentParent.Actions
local Thunks = scriptParentParent.Thunks
local HideMenu = require(Actions.HideMenu)
local SetLayout = require(Actions.SetLayout)
local ShowError = require(Actions.ShowError)
local HideError = require(Actions.HideError)
local OpenMenu = require(Thunks.OpenMenu)
local EmotesWheel = require(scriptParent.EmotesWheel)
local ErrorMessage = require(scriptParent.ErrorMessage)
local Constants = require(scriptParentParent.Constants)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = nil
local v26 = Roact.PureComponent:extend("EmotesMenu")

function v26.init(p1) -- line: 39
	p1.savedSelectedCoreObject = nil
	p1.savedSelectedObject = nil
end
function v26.displayVisitShopMessage(p2) -- line: 44
	-- upvalues: RobloxTranslator (copy), Constants (copy)
	local locale = p2.props.locale
	local v32 = RobloxTranslator:FormatByKeyForLocale(Constants.LocalizationKeys.VisitShopToGetEmotes, locale)

	p2.props.showError(v32)
	delay(Constants.ErrorDisplayTimeSeconds, function() -- line: 48
		-- upvalues: p2 (copy)
		p2.props.hideError()
	end)
end
function v26.bindActions(p3) -- line: 53
	-- upvalues: GuiService (copy), UserInputService (copy), ContextActionService (copy), Constants (copy)
	local function toggleMenuFunc(_, p5, _) -- line: 54
		-- upvalues: GuiService (copy), UserInputService (copy), p3 (copy)
		if GuiService.MenuIsOpen then
			return Enum.ContextActionResult.Pass
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
			return Enum.ContextActionResult.Pass
		end

		if p5 == Enum.UserInputState.Begin then
			if p3.props.displayOptions.menuVisible then
				p3.props.hideMenu()
			else
				p3.props.openMenu()
			end
		end

		return nil
	end

	ContextActionService:BindAction(Constants.ToggleMenuAction, toggleMenuFunc, false, Constants.EmoteMenuOpenKey)
end
function v26.unbindActions(_) -- line: 84
	-- upvalues: ContextActionService (copy), Constants (copy)
	ContextActionService:UnbindAction(Constants.ToggleMenuAction)
end
function v26.saveSelectedObject(p8) -- line: 88
	-- upvalues: GuiService (copy)
	p8.savedSelectedCoreObject = GuiService.SelectedCoreObject
	GuiService.SelectedCoreObject = nil
	p8.savedSelectedObject = GuiService.SelectedObject
	GuiService.SelectedObject = nil
end
function v26.resetSelectedObject(p9) -- line: 95
	-- upvalues: GuiService (copy), CoreGui (copy), PlayerGui (ref), LocalPlayer (copy)
	if GuiService.SelectedCoreObject == nil and (p9.savedSelectedCoreObject == nil or p9.savedSelectedCoreObject:IsDescendantOf(CoreGui)) then
		GuiService.SelectedCoreObject = p9.savedSelectedCoreObject
	end

	if GuiService.SelectedObject == nil then
		if PlayerGui == nil then
			PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		end

		if not not PlayerGui and (p9.savedSelectedObject == nil or p9.savedSelectedObject:IsDescendantOf(PlayerGui)) then
			GuiService.SelectedObject = p9.savedSelectedObject
		end
	end
end
function v26.viewPortSizeChanged(p10) -- line: 119
	-- upvalues: Constants (copy), Workspace (copy)
	if p10.props.layout == Constants.Layout.TenFoot then
		return
	end

	local CurrentCamera = Workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local ViewportSize = CurrentCamera.ViewportSize

	if ViewportSize == Vector2.new(1, 1) then
		return
	end

	local Large = Constants.Layout.Large
	local v42 = ViewportSize.X < Constants.SmallScreenMaxSize.X
	local v43 = ViewportSize.Y < Constants.SmallScreenMaxSize.Y

	if v42 or v43 then
		Large = Constants.Layout.Small
	end

	p10.props.setLayout(Large)
end
function v26.currentCameraChanged(p11) -- line: 147
	-- upvalues: Workspace (copy)
	if p11.viewportSizeChangedConn then
		p11.viewportSizeChangedConn:Disconnect()
	end

	local CurrentCamera = Workspace.CurrentCamera

	if CurrentCamera then
		p11.viewportSizeChangedConn = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 154
			-- upvalues: p11 (copy)
			p11:viewPortSizeChanged()
		end)
		p11:viewPortSizeChanged()
	end
end
function v26.didMount(p12) -- line: 161
	-- upvalues: Workspace (copy), GuiService (copy), VRService (copy), UserInputService (copy)
	p12.currentCameraChangedConn = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 162
		-- upvalues: p12 (copy)
		p12:currentCameraChanged()
	end)
	p12:currentCameraChanged()
	p12.menuOpenedConn = GuiService.MenuOpened:Connect(function() -- line: 167
		-- upvalues: p12 (copy), VRService (copy)
		if p12.props.displayOptions.menuVisible and not VRService.VREnabled then
			p12.props.hideMenu()
		end
	end)
	p12.inputOutsideMenuConn = UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 173
		-- upvalues: p12 (copy)
		if gameProcessed then
			return
		end

		if not p12.props.displayOptions.menuVisible then
			return
		end

		local UserInputType = input.UserInputType

		if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
			p12.props.hideMenu()
		end
	end)
	p12:bindActions()
end
function v26.willUnmount(p13) -- line: 193
	p13.currentCameraChangedConn:Disconnect()
	p13.viewportSizeChangedConn:Disconnect()
	p13.menuOpenedConn:Disconnect()
	p13.inputOutsideMenuConn:Disconnect()
	p13.currentCameraChangedConn = nil
	p13.viewportSizeChangedConn = nil
	p13.menuOpenedConn = nil
	p13.inputOutsideMenuConn = nil
	p13:unbindActions()
end
function v26.didUpdate(p14, p15, _) -- line: 207
	if p14.props.displayOptions.menuVisible ~= p15.displayOptions.menuVisible then
		if p14.props.displayOptions.menuVisible then
			p14:saveSelectedObject()

			return
		end

		p14:resetSelectedObject()
	end
end
function v26.render(p17) -- line: 217
	-- upvalues: Constants (copy), Roact (copy), EmotesWheel (copy), ErrorMessage (copy)
	local v52 = Constants.Layouts[p17.props.layout]
	local guiInset = p17.props.displayOptions.guiInset

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoLocalize = false,
		Position = UDim2.new(0, 0, 0, -guiInset),
		Size = UDim2.new(1, 0, 1, guiInset),
		ZIndex = Constants.EmotesMenuZIndex
	}, {
		Main = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = Constants.ScreenAvailable
		}, {
			AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			}),
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = v52.EmotesWheelMinSize,
				MaxSize = v52.EmotesWheelMaxSize
			}),
			EmotesWheel = Roact.createElement(EmotesWheel)
		}),
		ErrorMessage = Roact.createElement(ErrorMessage)
	})
end

local function mapStateToProps(p18) -- line: 251
	return {
		displayOptions = p18.displayOptions,
		emotesInfo = p18.emotesPage.emotesInfo,
		layout = p18.layout,
		locale = p18.locale
	}
end
local function mapDispatchToProps(p19) -- line: 260
	-- upvalues: OpenMenu (copy), HideMenu (copy), SetLayout (copy), ShowError (copy), HideError (copy)
	return {
		openMenu = function() -- line: 262
			-- upvalues: p19 (copy), OpenMenu (copy)
			return p19(OpenMenu())
		end,
		hideMenu = function() -- line: 266
			-- upvalues: p19 (copy), HideMenu (copy)
			return p19(HideMenu())
		end,
		setLayout = function(p20) -- line: 270
			-- upvalues: p19 (copy), SetLayout (copy)
			return p19(SetLayout(p20))
		end,
		showError = function(p21) -- line: 274
			-- upvalues: p19 (copy), ShowError (copy)
			return p19(ShowError(p21))
		end,
		hideError = function() -- line: 278
			-- upvalues: p19 (copy), HideError (copy)
			return p19(HideError())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v26)
