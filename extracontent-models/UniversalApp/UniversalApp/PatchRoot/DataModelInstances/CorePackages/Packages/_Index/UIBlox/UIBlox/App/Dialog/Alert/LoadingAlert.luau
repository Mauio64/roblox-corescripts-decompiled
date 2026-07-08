local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Alert = require(scriptParent.Alert)
local AlertType = require(scriptParent.Enum.AlertType)
local FitFrameOnAxis = require(ParentParentParent.FitFrame).FitFrameOnAxis
local Foundation = require(ParentParentParent.Foundation)
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local withStyle = require(ParentParent.Core.Style.withStyle)
local v14 = Roact.PureComponent:extend("LoadingAlert")

v14.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	screenSize = t.Vector2,
	onMounted = t.optional(t.callback),
	titleIcon = t.optional(t.union(t.table, t.string)),
	title = t.string
})

function v14.init(p1) -- line: 45
	-- upvalues: Roact (copy), Loading (copy), IconSize (copy)
	function p1.renderMiddleContent() -- line: 46
		-- upvalues: Roact (copy), Loading (copy), IconSize (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 48)
		}, {
			Spinner = Roact.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	end
end
function v14.render(p2) -- line: 60
	-- upvalues: withStyle (copy), Roact (copy), Alert (copy), AlertType (copy), FitFrameOnAxis (copy), ImageSetComponent (copy)
	return withStyle(function(p3) -- line: 61
		-- upvalues: Roact (copy), Alert (copy), p2 (copy), AlertType (copy), FitFrameOnAxis (copy), ImageSetComponent (copy)
		local Theme = p3.Theme

		return Roact.createElement(Alert, {
			maxWidth = 400,
			minWidth = 272,
			anchorPoint = p2.props.anchorPoint,
			alertType = AlertType.Loading,
			margin = {
				top = 0,
				bottom = 24,
				left = 24,
				right = 24
			},
			middleContent = p2.renderMiddleContent,
			onMounted = p2.props.onMounted,
			position = p2.props.position,
			screenSize = p2.props.screenSize,
			title = p2.props.title,
			titleContent = p2.props.titleIcon and function() -- line: 81
				-- upvalues: Roact (copy), FitFrameOnAxis (copy), ImageSetComponent (copy), p2 (copy), Theme (copy)
				return Roact.createElement(FitFrameOnAxis, {
					BackgroundTransparency = 1,
					contentPadding = UDim.new(0, 8),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					margin = {
						top = 12,
						bottom = 0,
						left = 0,
						right = 0
					},
					minimumSize = UDim2.new(1, 0, 0, 0)
				}, {
					Icon = Roact.createElement(ImageSetComponent.Label, {
						BackgroundTransparency = 1,
						Image = p2.props.titleIcon,
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = Theme.IconEmphasis.Transparency,
						Size = UDim2.new(0, 48, 0, 48)
					})
				})
			end or nil
		})
	end)
end

return v14
