local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local PropertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local DevConsoleMaster = require(CoreGui.RobloxGui.Modules.DevConsoleMaster)
local ParentParent = script.Parent.Parent.Parent
local Divider = require(ParentParent.Components.Divider)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local Page = require(script.Parent.Parent.Page)
local CategoryHeader = require(script.Parent.CategoryHeader)
local ToggleEntry = require(script.Parent.ToggleEntry)
local VersionReporter = require(script.Parent.VersionReporter)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local withLocalization = require(ParentParent.Localization.withLocalization)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local Flags = ParentParent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(Flags.GetFFlagIGMGamepadSelectionHistory)
local v29 = Roact.PureComponent:extend("AdvancedPage")

v29.validateProps = t.strictInterface({
	canCaptureFocus = t.boolean,
	closeMenu = t.callback,
	pageTitle = t.string,
	currentPage = GetFFlagIGMGamepadSelectionHistory() and t.string or nil,
	currentZone = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil
})

function v29.init(p1) -- line: 53
	-- upvalues: UserGameSettings (copy), Roact (copy)
	p1:setState({
		microProfilerEnabled = UserGameSettings.OnScreenProfilerEnabled,
		performanceStatsEnabled = UserGameSettings.PerformanceStatsVisible
	})
	p1.backButtonRef = Roact.createRef()
	p1.performanceToggleRef = Roact.createRef()
end

if not GetFFlagIGMGamepadSelectionHistory() then
	function v29.didUpdate(p2, p3) -- line: 64
		-- upvalues: GuiService (copy)
		if p2.props.canCaptureFocus and not p3.canCaptureFocus then
			GuiService.SelectedCoreObject = p2.performanceToggleRef:getValue()
		end
	end
end

function v29.renderWithSelectionCursor(p4, p5) -- line: 71
	-- upvalues: withStyle (copy), Roact (copy), Page (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), Constants (copy), GuiService (copy), CategoryHeader (copy), ToggleEntry (copy), UserGameSettings (copy), SendAnalytics (copy), withLocalization (copy), CursorKind (copy), DevConsoleMaster (copy), Divider (copy), VersionReporter (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy)
	return withStyle(function(p6) -- line: 72
		-- upvalues: Roact (copy), Page (copy), p4 (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), Constants (copy), GuiService (copy), CategoryHeader (copy), ToggleEntry (copy), UserGameSettings (copy), SendAnalytics (copy), withLocalization (copy), p5 (copy), CursorKind (copy), DevConsoleMaster (copy), Divider (copy), VersionReporter (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy)
		return Roact.createElement(Page, {
			zIndex = 2,
			pageTitle = p4.props.pageTitle,
			position = p4.props.position,
			buttonRef = p4.backButtonRef,
			NextSelectionDown = p4.performanceToggleRef
		}, {
			FocusHandler = GetFFlagIGMGamepadSelectionHistory() and Roact.createElement(FocusHandler, {
				isFocused = p4.props.canCaptureFocus,
				shouldForgetPreviousSelection = p4.props.currentPage ~= Constants.advancedSettingsPageKey or p4.props.currentZone == 0,
				didFocus = function(p7) -- line: 85
					-- upvalues: GuiService (copy), p4 (copy)
					GuiService.SelectedCoreObject = p7 or p4.performanceToggleRef:getValue()
				end
			}) or nil,
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			AdvancedHeader = Roact.createElement(CategoryHeader, {
				LayoutOrder = 1,
				localizationKey = "CoreScripts.InGameMenu.GameSettings.AdvancedSettingsTitle"
			}),
			PerformanceStats = Roact.createElement(ToggleEntry, {
				LayoutOrder = 2,
				labelKey = "CoreScripts.InGameMenu.GameSettings.ShowPerfStats",
				checked = p4.state.performanceStatsEnabled,
				onToggled = function() -- line: 103
					-- upvalues: UserGameSettings (copy), SendAnalytics (copy), Constants (copy)
					UserGameSettings.PerformanceStatsVisible = not UserGameSettings.PerformanceStatsVisible
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end,
				buttonRef = p4.performanceToggleRef,
				NextSelectionUp = p4.backButtonRef
			}),
			MicroProfiler = Roact.createElement(ToggleEntry, {
				LayoutOrder = 3,
				labelKey = "CoreScripts.InGameMenu.GameSettings.ShowMicroProfiler",
				checked = p4.state.microProfilerEnabled,
				onToggled = function() -- line: 114
					-- upvalues: UserGameSettings (copy), SendAnalytics (copy), Constants (copy)
					UserGameSettings.OnScreenProfilerEnabled = not UserGameSettings.OnScreenProfilerEnabled
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end
			}),
			DeveloperConsole = withLocalization({
				text = "CoreScripts.InGameMenu.GameSettings.DeveloperConsole"
			})(function(p8) -- line: 121
				-- upvalues: Roact (copy), p6 (copy), p5 (copy), CursorKind (copy), DevConsoleMaster (copy), p4 (copy)
				return Roact.createElement("TextButton", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 54),
					Text = p8.text,
					TextColor3 = p6.Theme.TextEmphasis.Color,
					Font = p6.Font.Header2.Font,
					TextSize = p6.Font.Header2.RelativeSize * p6.Font.BaseSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 4,
					SelectionImageObject = p5(CursorKind.Square),
					[Roact.Event.Activated] = function() -- line: 132
						-- upvalues: DevConsoleMaster (copy), p4 (copy)
						DevConsoleMaster:SetVisibility(true)
						p4.props.closeMenu()
					end
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 24)
					})
				})
			end),
			Divider = Roact.createElement(Divider, {
				LayoutOrder = 5,
				Size = UDim2.new(1, -24, 0, 1)
			}),
			VersionReporter = Roact.createElement(VersionReporter, {
				LayoutOrder = 6
			}),
			MicroProfilerVisibilityListener = Roact.createElement(ExternalEventConnection, {
				event = PropertyChangedSignal,
				callback = function() -- line: 152
					-- upvalues: p4 (copy), UserGameSettings (copy)
					p4:setState({
						microProfilerEnabled = UserGameSettings.OnScreenProfilerEnabled
					})
				end
			}),
			PerformanceStatsVisibilityListener = Roact.createElement(ExternalEventConnection, {
				event = UserGameSettings.PerformanceStatsVisibleChanged,
				callback = function() -- line: 160
					-- upvalues: p4 (copy), UserGameSettings (copy)
					p4:setState({
						performanceStatsEnabled = UserGameSettings.PerformanceStatsVisible
					})
				end
			})
		})
	end)
end
function v29.render(p9) -- line: 170
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p10) -- line: 171
		-- upvalues: p9 (copy)
		return p9:renderWithSelectionCursor(p10)
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p11) -- line: 176
	-- upvalues: Constants (copy), GetFFlagIGMGamepadSelectionHistory (copy)
	local v37 = p11.menuPage == "AdvancedGameSettings" and (p11.displayOptions.inputType == Constants.InputType.Gamepad and (not p11.respawn.dialogOpen and p11.currentZone == 1))
	local currentZone = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = p11.currentZone
	end

	return {
		canCaptureFocus = v37,
		currentPage = GetFFlagIGMGamepadSelectionHistory() and p11.menuPage or nil,
		currentZone = currentZone
	}
end, function(p12) -- line: 192
	-- upvalues: CloseMenu (copy)
	return {
		closeMenu = function() -- line: 194
			-- upvalues: p12 (copy), CloseMenu (copy)
			p12(CloseMenu)
		end
	}
end)(v29)
