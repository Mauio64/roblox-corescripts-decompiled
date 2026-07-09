local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(Modules.LuaApp.withLocalization)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local v13 = Roact.PureComponent:extend("UserAgreementsSecondPrompt")

v13.validateProps = t.strictInterface({
	agreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string
	})),
	agreementsListItems = t.table,
	screenSize = t.Vector2,
	showFirstPrompt = t.callback
})

function v13.init(p1) -- line: 33
	-- upvalues: Roact (copy)
	function p1.onAck() -- line: 34
		-- upvalues: p1 (copy)
		local agreements = p1.props.agreements

		p1.props.showFirstPrompt(agreements)
	end
	function p1.renderMiddleContent(p2, t1: {[any]: any}) -- line: 40
		-- upvalues: p1 (copy), Roact (copy)
		local Theme = t1.Theme
		local t1Font = t1.Font
		local agreementsListItems = p1.props.agreementsListItems

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Agreements = Roact.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Prefix = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 12)
				}, {
					PrefixText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 1, 0),
						Text = p2.bodyTextPart1,
						Font = t1Font.CaptionHeader.Font,
						TextSize = t1Font.BaseSize * t1Font.CaptionHeader.RelativeSize,
						TextColor3 = Theme.TextDefault.Color,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 12)
					})
				}),
				AgreementsList = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY
				}, agreementsListItems),
				Suffix = Roact.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 12)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 12)
					}),
					PrefixText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 1, 0),
						Text = p2.bodyTextPart2,
						Font = t1Font.CaptionHeader.Font,
						TextSize = t1Font.BaseSize * t1Font.CaptionHeader.RelativeSize,
						TextColor3 = Theme.TextDefault.Color,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					})
				})
			})
		})
	end
end
function v13.render(p3) -- line: 116
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local screenSize = p3.props.screenSize

	return withStyle(function(p4) -- line: 118
		-- upvalues: withLocalization (copy), Roact (copy), InteractiveAlert (copy), p3 (copy), ButtonType (copy), screenSize (copy)
		return withLocalization({
			title = "Luobu.Authentication.UserAgreementsSecondPrompt.Title",
			bodyTextPart1 = "Luobu.Authentication.UserAgreementsSecondPrompt.BodyText.Part1",
			bodyTextPart2 = "Luobu.Authentication.UserAgreementsSecondPrompt.BodyText.Part2",
			buttonText = "Luobu.Authentication.UserAgreementsSecondPrompt.Button.Acknowledge"
		})(function(p5) -- line: 124
			-- upvalues: Roact (copy), InteractiveAlert (copy), p3 (copy), p4 (copy), ButtonType (copy), screenSize (copy)
			return Roact.createElement(InteractiveAlert, {
				title = p5.title,
				middleContent = function() -- line: 127
					-- upvalues: p3 (copy), p5 (copy), p4 (copy)
					return p3.renderMiddleContent(p5, p4)
				end,
				buttonStackInfo = {
					buttons = {{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = p3.onAck,
							text = p5.buttonText
						}
					}}
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = screenSize
			})
		end)
	end)
end

return (RoactRodux.connect(function(p6) -- line: 148
	return {
		screenSize = p6.ScreenSize
	}
end, function(p7) -- line: 152
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy)
	return {
		showFirstPrompt = function(p8) -- line: 154
			-- upvalues: p7 (copy), SetCentralOverlay (copy), OverlayType (copy)
			p7(SetCentralOverlay(OverlayType.UserAgreementsPrompt, {
				agreements = p8,
				context = OverlayType.UserAgreementsSecondPrompt
			}))
		end
	}
end)(v13))
