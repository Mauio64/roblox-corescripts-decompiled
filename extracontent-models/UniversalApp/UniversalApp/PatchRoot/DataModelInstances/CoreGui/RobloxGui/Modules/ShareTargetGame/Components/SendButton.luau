local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local v9 = Roact.PureComponent:extend("SendButton")

v9.defaultProps = {
	sendText = "Send",
	sentText = "Sent!",
	sendingText = "Sending..",
	failedText = "Failed",
	sentStatus = nil,
	isLoading = false,
	onActivated = function() -- line: 27
		-- upvalues: Promise (copy)
		return Promise.resolve()
	end
}

function v9.render(p1) -- line: 32
	-- upvalues: UIBlox (copy), Text (copy), Roact (copy), Skeleton (copy), EnumsRadius (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 33
		-- upvalues: p1 (copy), Text (copy), Roact (copy), Skeleton (copy), EnumsRadius (copy)
		local v12 = if p1.props.sentStatus ~= "sent" then if p1.props.sentStatus ~= "sending" then if p1.props.sentStatus ~= "failed" then p1.props.sendText else p1.props.failedText else p1.props.sendingText else p1.props.sentText
		local BodyFont = p2.Font.Body.Font
		local v14 = p2.Font.BaseSize * p2.Font.Body.RelativeSize
		local v15 = Text.GetTextWidth(v12, BodyFont, v14)
		local v16 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			inactiveButton = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				TextSize = v14,
				TextColor3 = p2.Theme.TextDefault.Color,
				TextTransparency = p2.Theme.TextDefault.Transparency,
				Font = BodyFont,
				TextXAlignment = Enum.TextXAlignment.Right,
				Text = v12
			})
		})
		local v17 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			activeButton = Roact.createElement("ImageButton", {
				BackgroundTransparency = 1,
				ImageColor3 = p2.Theme.SecondaryDefault.Color,
				ImageTransparency = p2.Theme.SecondaryDefault.Transparency,
				Image = "rbxasset:///textures/ui/LuaDiscussions/buttonStroke.png",
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 8, 8),
				Size = UDim2.new(1, 0, 1, 0),
				[Roact.Event.Activated] = p1.props.onActivated
			}, {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				interior = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
					Size = UDim2.new(1, -2, 1, -2)
				}, {
					layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					Label = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, v15, 0, v14),
						Text = v12,
						Font = BodyFont,
						TextSize = v14,
						TextColor3 = p2.Theme.SecondaryContent.Color,
						TextTransparency = p2.Theme.SecondaryContent.Transparency
					})
				})
			})
		})

		return not p1.props.isLoading and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v15 + 14, 0, 32)
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			element = p1.props.sentStatus and v16 or v17
		}) or Roact.createElement(Skeleton, {
			Size = UDim2.new(0, v15 + 14, 0, 32),
			radius = EnumsRadius.Small
		})
	end)
end

return v9
