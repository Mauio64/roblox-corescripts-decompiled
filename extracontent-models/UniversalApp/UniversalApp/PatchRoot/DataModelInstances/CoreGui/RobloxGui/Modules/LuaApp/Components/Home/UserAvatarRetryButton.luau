local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)
local RetryButton = require(Modules.LuaApp.Components.RetryButton)
local LocalizedTextLabel = require(Modules.LuaApp.Components.LocalizedTextLabel)
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local v8 = Roact.PureComponent:extend("UserAvatarRetryButton")

function v8.render(p1) -- line: 19
	-- upvalues: Roact (copy), FitChildren (copy), RetryButton (copy), LocalizedTextLabel (copy)
	local appTheme = p1.props.appTheme
	local position = p1.props.position
	local anchorPoint = p1.props.anchorPoint
	local maxTextWidth = p1.props.maxTextWidth
	local onRetry = p1.props.onRetry
	local uDim2 = UDim2.new(1, 0, 0, 72)

	if maxTextWidth then
		uDim2 = UDim2.new(0, maxTextWidth, 0, 72)
	end

	return Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		Position = position,
		AnchorPoint = anchorPoint
	}, {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 40)
		}),
		RetryButton = Roact.createElement(RetryButton, {
			layoutOrder = 1,
			onRetry = onRetry,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}),
		FailMessage = Roact.createElement(LocalizedTextLabel, {
			LayoutOrder = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Text = "Feature.Avatar.Message.FailedToLoadAvatar",
			TextScaled = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = uDim2,
			TextColor3 = appTheme.Main.BodyText.Color,
			Font = appTheme.Main.BodyText.Font
		}, {
			UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = 24
			})
		})
	})
end

return (withTheme_DEPRECATED(v8))
