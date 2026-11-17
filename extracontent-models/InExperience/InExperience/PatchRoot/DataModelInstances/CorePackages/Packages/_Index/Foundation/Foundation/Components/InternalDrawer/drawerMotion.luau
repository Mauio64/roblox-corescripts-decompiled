local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Otter = require(parent.Otter)
local React = require(parent.React)

require(Foundation.Providers.Style.Tokens)
local DrawerMotion = {}

function DrawerMotion.animate(data, flag: boolean, p, flag2: boolean)
	local startingValue = data.drag:getValue()
	local startingValue2

	if startingValue ~= nil then
		startingValue2 = 1 - startingValue
	end

	if flag2 then
		data.setPanelGoal(Otter.instant(flag and 1 or 0))
		data.setBackdropGoal(Otter.instant(flag and 0 or 1))
	elseif flag then
		data.setPanelGoal(Otter.ease(1, {
			easingStyle = p.Ease.StandardOut,
			duration = p.Time.Time_300,
			startingValue = startingValue
		}))

		data.setBackdropGoal(Otter.ease(0, {
			duration = p.Time.Time_100,
			startingValue = startingValue2
		}))
	else
		data.setPanelGoal(Otter.ease(0, {
			easingStyle = p.Ease.StandardIn,
			duration = p.Time.Time_100,
			startingValue = startingValue
		}))

		data.setBackdropGoal(Otter.ease(1, {
			duration = p.Time.Time_100,
			startingValue = startingValue2
		}))
	end

	if startingValue ~= nil then
		data.setDrag(nil)
	end
end

function DrawerMotion.hold(data)
	data.setPanelGoal(Otter.instant(data.panelProgress:getValue()))
	data.setBackdropGoal(Otter.instant(data.backdropTransparency:getValue()))
end

function DrawerMotion.useDrag()
	local v = React.useState(function()
		local binding, setDrag = React.createBinding(nil)
		return { drag = binding, setDrag = setDrag }
	end)

	return v.drag, v.setDrag
end

return DrawerMotion
