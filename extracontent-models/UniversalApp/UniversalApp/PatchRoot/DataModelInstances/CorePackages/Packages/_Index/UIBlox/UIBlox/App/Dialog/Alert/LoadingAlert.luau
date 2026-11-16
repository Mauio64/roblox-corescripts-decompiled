local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)

local Alert = require(parent.Alert)
local AlertType = require(parent.Enum.AlertType)

local FitFrame = require(parent3.FitFrame)
local FitFrameOnAxis = FitFrame.FitFrameOnAxis

local Foundation = require(parent3.Foundation)
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local withStyle = require(parent2.Core.Style.withStyle)

local extended = Roact.PureComponent:extend("LoadingAlert")

extended.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	screenSize = t.Vector2,
	onMounted = t.optional(t.callback),
	titleIcon = t.optional(t.union(t.table, t.string)),
	title = t.string
})

function extended:init()
	function self.renderMiddleContent()
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 48),
			BackgroundTransparency = 1
		}, {
			Spinner = Roact.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	end
end

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme

		return Roact.createElement(Alert, {
			anchorPoint = p.props.anchorPoint,
			alertType = AlertType.Loading,
			margin = { top = 0, bottom = 24, left = 24, right = 24 },
			maxWidth = 400,
			minWidth = 272,
			middleContent = p.renderMiddleContent,
			onMounted = p.props.onMounted,
			position = p.props.position,
			screenSize = p.props.screenSize,
			title = p.props.title,
			titleContent = p.props.titleIcon and function()
				return Roact.createElement(FitFrameOnAxis, {
					BackgroundTransparency = 1,
					contentPadding = UDim.new(0, 8),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					margin = { top = 12, bottom = 0, left = 0, right = 0 },
					minimumSize = UDim2.new(1, 0, 0, 0)
				}, {
					Icon = Roact.createElement(ImageSetComponent.Label, {
						BackgroundTransparency = 1,
						Image = p.props.titleIcon,
						ImageColor3 = theme.IconEmphasis.Color,
						ImageTransparency = theme.IconEmphasis.Transparency,
						Size = UDim2.new(0, 48, 0, 48)
					})
				})
			end or nil
		})
	end)
end

return extended
