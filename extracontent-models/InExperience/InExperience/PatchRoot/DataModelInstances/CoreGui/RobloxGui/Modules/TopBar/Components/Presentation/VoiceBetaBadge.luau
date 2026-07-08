local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local VRService = game:GetService("VRService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withStyle = require(CorePackages.Packages.UIBlox).Core.Style.withStyle
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

require(RobloxGui.Modules.TenFootInterface)
require(RobloxGui.Modules.isNewInGameMenuEnabled)
require(RobloxGui.Modules.InGameMenuConstants)

local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local v13 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local v16 = Roact.PureComponent:extend("MenuIcon")
local GetFStringVoiceBetaBadgeLearnMore = require(RobloxGui.Modules.Flags.GetFStringVoiceBetaBadgeLearnMore)
local GetFFlagBetaBadgeLearnMoreLinkFormview = require(RobloxGui.Modules.Flags.GetFFlagBetaBadgeLearnMoreLinkFormview)
local ParentParent = script.Parent.Parent.Parent
local SetKeepOutArea = require(ParentParent.Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(ParentParent.Actions.RemoveKeepOutArea)
local Constants = require(ParentParent.Constants)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local Chrome = ParentParent.Parent.Chrome

if require(CorePackages.Workspace.Packages.Chrome).Enabled() then
	require(Chrome.Service)
end

v16.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	Analytics = t.table,
	setKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.optional(t.callback) else nil,
	removeKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.optional(t.callback) else nil
})

local _ = {
	FullScreen = 0,
	FormSheet = 2
}
local uDim2 = UDim2.fromOffset(31, 11)
local uDim = UDim.new(0, 12)
local uDim2_2 = UDim2.fromOffset(330, 185)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function v31() -- line: 62
end

function openWebview(p1) -- line: 67
	-- upvalues: HttpService (copy), GetFFlagBetaBadgeLearnMoreLinkFormview (copy), v13 (copy), GuiService (copy)
	local json = HttpService:JSONEncode({
		visible = true,
		title = if not game:GetEngineFeature("SetWebViewTitle") then nil else "Help Center",
		presentationStyle = if not GetFFlagBetaBadgeLearnMoreLinkFormview() then nil else 2,
		url = p1
	})

	v13:debug("Opening Webview with payload {}", json)
	GuiService:BroadcastNotification(json, 20)
end
function v16.init(p2) -- line: 80
	-- upvalues: Roact (copy), VRService (copy), GamepadService (copy), default (copy), v31 (copy), GetFStringVoiceBetaBadgeLearnMore (copy), FFlagTopBarSignalizeKeepOutAreas (copy), CoreGuiCommon (copy)
	p2.buttonRef = Roact.createRef()
	p2:setState({
		voiceChatServiceConnected = false,
		showPopup = false,
		vrShowMenuIcon = VRService.VREnabled and GamepadService.GamepadCursorEnabled
	})

	if game:GetEngineFeature("VoiceChatSupported") then
		default:asyncInit():andThen(function() -- line: 91
			-- upvalues: p2 (copy)
			p2:setState({
				voiceChatServiceConnected = true
			})
		end):catch(v31)
	end

	function p2.menuIconActivated() -- line: 99
		-- upvalues: p2 (copy)
		p2:setState({
			showPopup = not p2.state.showPopup
		})
		p2.props.Analytics.EventStream:setRBXEvent("voiceChat", p2.state.showPopup and "closeBetaBadge" or "openBetaBadge")
	end
	function p2.learnMore() -- line: 109
		-- upvalues: GetFStringVoiceBetaBadgeLearnMore (copy), p2 (copy)
		local v40 = GetFStringVoiceBetaBadgeLearnMore()

		openWebview(v40)
		p2.props.Analytics.EventStream:setRBXEvent("voiceChat", "clickBetaBadgeLearnMore")
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		p2.keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end
end
function v16.render(p3) -- line: 121
	-- upvalues: VRService (copy), FFlagTopBarSignalizeKeepOutAreas (copy), Constants (copy), withStyle (copy), Roact (copy), uDim2_2 (copy), RobloxTranslator (copy), uDim (copy), uDim2 (copy), AppFonts (copy), GamepadService (copy), ExternalEventConnection (copy)
	local v37 = (not VRService.VREnabled or p3.state.vrShowMenuIcon) and p3.state.voiceChatServiceConnected

	local function v38(p4) -- line: 124
		-- upvalues: v37 (copy), FFlagTopBarSignalizeKeepOutAreas (copy), p3 (copy), Constants (copy)
		if v37 and p4 then
			local vector2 = Vector2.new(p4.AbsolutePosition.X - 2, p4.AbsolutePosition.Y - 2)
			local vector2_2 = Vector2.new(p4.AbsoluteSize.X + 4, p4.AbsoluteSize.Y + 4)

			if FFlagTopBarSignalizeKeepOutAreas then
				p3.keepOutAreasStore.setKeepOutArea(Constants.VoiceBetaBadgeKeepOutAreaId, vector2, vector2_2)

				return
			end

			p3.props.setKeepOutArea(Constants.VoiceBetaBadgeKeepOutAreaId, vector2, vector2_2)

			return
		end

		if FFlagTopBarSignalizeKeepOutAreas then
			p3.keepOutAreasStore.removeKeepOutArea(Constants.VoiceBetaBadgeKeepOutAreaId)

			return
		end

		p3.props.removeKeepOutArea(Constants.VoiceBetaBadgeKeepOutAreaId)
	end

	if p3.buttonRef.current then
		v38(p3.buttonRef.current)
	end

	return withStyle(function(p5) -- line: 148
		-- upvalues: Roact (copy), v37 (copy), p3 (copy), uDim2_2 (copy), RobloxTranslator (copy), uDim (copy), v38 (copy), uDim2 (copy), AppFonts (copy), GamepadService (copy), ExternalEventConnection (copy), VRService (copy)
		local Footer = p5.Font.Footer
		local FooterFont = Footer.Font
		local v47 = p5.Font.BaseSize * Footer.RelativeSize
		local BackgroundUIContrast = p5.Theme.BackgroundUIContrast
		local TextEmphasis = p5.Theme.TextEmphasis
		local TextLink = p5.Theme.TextLink
		local color3 = Color3.fromRGB(238, 206, 83)

		return Roact.createFragment({
			PopupWrapper = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Visible = v37 and p3.state.showPopup,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = p3.props.layoutOrder + 1
			}, {
				Popup = Roact.createElement("Frame", {
					Size = uDim2_2,
					Position = UDim2.fromOffset(0, 10),
					BackgroundTransparency = BackgroundUIContrast.Transparency,
					BackgroundColor3 = BackgroundUIContrast.Color
				}, {
					Layout = Roact.createElement("UIListLayout", {
						Padding = UDim.new(0, 8),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Popup = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 0,
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						Layout = Roact.createElement("UIListLayout", {
							Padding = UDim.new(0, 0),
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Starter = Roact.createElement("TextLabel", {
							LayoutOrder = 0,
							BackgroundTransparency = 1,
							Text = RobloxTranslator:FormatByKey("InGame.CommonUI.Badge.Popup.HeaderList"),
							TextSize = v47,
							Font = FooterFont,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextColor3 = TextEmphasis.Color,
							AutomaticSize = Enum.AutomaticSize.XY
						}),
						FirstBullet = Roact.createElement("TextLabel", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Text = "• " .. RobloxTranslator:FormatByKey("InGame.CommonUI.Badge.Popup.VoiceChatBullet"),
							TextSize = v47,
							Font = FooterFont,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextColor3 = TextEmphasis.Color,
							AutomaticSize = Enum.AutomaticSize.XY
						})
					}),
					Text = Roact.createElement("TextLabel", {
						LayoutOrder = 0,
						TextWrapped = true,
						BackgroundTransparency = 1,
						Text = RobloxTranslator:FormatByKey("InGame.CommonUI.Badge.Popup.DisclaimerText2"),
						TextSize = v47,
						Font = FooterFont,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = TextEmphasis.Color,
						AutomaticSize = Enum.AutomaticSize.XY
					}),
					LearnMoreLink = Roact.createElement("TextButton", {
						Text = RobloxTranslator:FormatByKey("InGame.CommonUI.Badge.Popup.LearnMoreLink"),
						TextSize = v47,
						Font = FooterFont,
						LayoutOrder = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = TextLink.Color,
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						[Roact.Event.Activated] = p3.learnMore
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					}),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingLeft = uDim,
						PaddingRight = uDim,
						PaddingBottom = uDim,
						PaddingTop = uDim
					})
				})
			}),
			Button = Roact.createElement("Frame", {
				Visible = v37,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = p3.props.layoutOrder,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 1),
				[Roact.Change.AbsoluteSize] = v38,
				[Roact.Change.AbsolutePosition] = v38,
				[Roact.Ref] = p3.buttonRef
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ActualButton = Roact.createElement("Frame", {
					BackgroundTransparency = 0,
					Visible = v37,
					Size = uDim2,
					BackgroundColor3 = color3
				}, {
					Button = Roact.createElement("TextButton", {
						Text = RobloxTranslator:FormatByKey("InGame.CommonUI.Badge.BadgeText"),
						Font = AppFonts.default:getBold(),
						TextSize = 8,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = uDim2,
						TextColor3 = BackgroundUIContrast.Color,
						[Roact.Event.Activated] = p3.menuIconActivated
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 3)
					}),
					UIStroke = Roact.createElement("UIStroke", {
						Thickness = 2,
						Color = TextEmphasis.Color
					}),
					VREnabledListener = GamepadService and Roact.createElement(ExternalEventConnection, {
						event = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"),
						callback = function() -- line: 282
							-- upvalues: p3 (copy), VRService (copy), GamepadService (copy)
							p3:setState({
								vrShowMenuIcon = VRService.VREnabled and GamepadService.GamepadCursorEnabled
							})
						end or nil
					})
				})
			})
		})
	end)
end

local function mapDispatchToProps(p6) -- line: 294
	-- upvalues: FFlagTopBarSignalizeKeepOutAreas (copy), SetKeepOutArea (copy), RemoveKeepOutArea (copy)
	if FFlagTopBarSignalizeKeepOutAreas then
		return {}
	end

	return {
		setKeepOutArea = function(p7, p8, p9) -- line: 299
			-- upvalues: p6 (copy), SetKeepOutArea (copy)
			return p6(SetKeepOutArea(p7, p8, p9))
		end,
		removeKeepOutArea = function(p10) -- line: 302
			-- upvalues: p6 (copy), RemoveKeepOutArea (copy)
			return p6(RemoveKeepOutArea(p10))
		end
	}
end

if FFlagTopBarSignalizeKeepOutAreas then
	return v16
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v16)
