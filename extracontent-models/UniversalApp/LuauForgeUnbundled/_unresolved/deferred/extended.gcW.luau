local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text

local extended = Roact.PureComponent:extend("SendButton")

extended.defaultProps = {
	sendText = "Send",
	sentText = "Sent!",
	sendingText = "Sending..",
	failedText = "Failed",
	sentStatus = nil,
	isLoading = false,
	onActivated = function()
		return Promise.resolve()
	end
}

function extended.render(p2)
	return UIBlox.Style.withStyle(function(props)
		local v5

		if p2.props.sentStatus == "sent" then
			v5 = p2.props.sentText
		elseif p2.props.sentStatus == "sending" then
			v5 = p2.props.sendingText
		else
			v5 = if p2.props.sentStatus == "failed" then p2.props.failedText else p2.props.sendText
		end

		local font = props.Font.Body.Font
		local v6 = props.Font.BaseSize * props.Font.Body.RelativeSize
		local v7

		if foundationFontFaceMigration then
			v7 = getTextSize(v5, v6, props.Tokens.Typography.BodyLarge.Font, Vector2.new(10000, 10000)).X
		else
			v7 = text.GetTextWidth(v5, font, v6)
		end

		local createElement = Roact.createElement
		local v9 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }

		local createElement2 = Roact.createElement
		local v12 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			TextSize = v6,
			TextColor3 = props.Theme.TextDefault.Color,
			TextTransparency = props.Theme.TextDefault.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextXAlignment = 0,
			Text = 0
		}

		local v14 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v12.FontFace = v14

		v12.TextXAlignment = Enum.TextXAlignment.Right
		v12.Text = v5
		local element = createElement("Frame", v9, {
			inactiveButton = createElement2("TextLabel", v12)
		})

		local createElement3 = Roact.createElement
		local v16 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}
		local v17 = {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			activeButton = 0
		}

		local createElement4 = Roact.createElement
		local onActivatedsByActivated = {
			BackgroundTransparency = 1,
			ImageColor3 = props.Theme.SecondaryDefault.Color,
			ImageTransparency = props.Theme.SecondaryDefault.Transparency,
			Image = "rbxasset:///textures/ui/LuaDiscussions/buttonStroke.png",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 8, 8),
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Event.Activated] = p2.props.onActivated
		}
		local v19 = {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			interior = 0
		}

		local createElement5 = Roact.createElement
		local v21 = {
			BackgroundColor3 = props.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -2, 1, -2)
		}
		local v22 = {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Label = 0
		}

		local createElement6 = Roact.createElement
		local v24 = {
			Size = UDim2.new(0, v7, 0, v6),
			BackgroundTransparency = 1,
			Text = v5,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}

		if foundationFontFaceMigration then
			font = nil
		end

		v24.Font = font

		local v25 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v24.FontFace = v25

		v24.TextSize = v6
		v24.TextColor3 = props.Theme.SecondaryContent.Color
		v24.TextTransparency = props.Theme.SecondaryContent.Transparency
		v22.Label = createElement6("TextLabel", v24)
		v19.interior = createElement5("Frame", v21, v22)
		v17.activeButton = createElement4("ImageButton", onActivatedsByActivated, v19)
		local v26 = createElement3("Frame", v16, v17)
		local v27

		if p2.props.isLoading then
			v27 = Roact.createElement(skeleton, {
				Size = UDim2.new(0, v7 + 14, 0, 32),
				radius = radius.Small
			})
		else
			local createElement7 = Roact.createElement
			local v29 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v7 + 14, 0, 32)
			}
			local v30 = {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				element = 0
			}

			v26 = p2.props.sentStatus and element or v26
			v30.element = v26
			v27 = createElement7("Frame", v29, v30) or Roact.createElement(skeleton, {
				Size = UDim2.new(0, v7 + 14, 0, 32),
				radius = radius.Small
			})
		end

		return v27
	end)
end

return extended
