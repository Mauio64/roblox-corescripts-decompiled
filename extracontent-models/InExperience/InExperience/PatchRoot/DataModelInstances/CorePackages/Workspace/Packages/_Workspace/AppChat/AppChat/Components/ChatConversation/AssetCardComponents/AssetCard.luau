local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local Header = require(script.Parent.Header)
local Body = require(script.Parent.Body)
local FitFrameVertical = require(script.Parent.FitFrameVertical)
local v7 = Roact.PureComponent:extend("AssetCard")

v7.defaultProps = {
	cardTitle = nil,
	cardIcon = nil,
	cardBodyText = nil,
	contentLoadedCallback = nil,
	bodyActivated = function() -- line: 25
		print("Card body was activated!")
	end
}

function v7.render(p1) -- line: 30
	-- upvalues: Roact (copy), UIBlox (copy), FitFrameVertical (copy), Header (copy), Body (copy)
	local v9 = p1.props[Roact.Children]

	return UIBlox.Style.withStyle(function(_) -- line: 33
		-- upvalues: Roact (copy), FitFrameVertical (copy), Header (copy), p1 (copy), Body (copy), v9 (copy)
		return Roact.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			Visible = true,
			LayoutOrder = 2,
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 5)
		}, {
			topSpacing = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 12)
			}, {
				header = Roact.createElement(Header, {
					LayoutOrder = 1,
					cardTitle = p1.props.cardTitle or nil,
					isLoading = p1.props.isLoading
				}),
				body = Roact.createElement(Body, {
					LayoutOrder = 2,
					cardIcon = p1.props.cardIcon,
					cardBodyText = p1.props.cardBodyText or nil,
					isLoading = p1.props.isLoading,
					contentLoadedCallback = p1.props.contentLoadedCallback,
					bodyActivated = p1.props.bodyActivated
				})
			}),
			bottomSpacing = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				width = UDim.new(1, 0)
			}, v9)
		})
	end)
end

return v7
