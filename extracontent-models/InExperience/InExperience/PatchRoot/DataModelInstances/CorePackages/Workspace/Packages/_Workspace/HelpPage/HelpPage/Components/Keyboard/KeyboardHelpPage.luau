local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local useKeybinds = require(ParentParent.Hooks.useKeybinds)
local KeyboardGroup = require(script.Parent.KeyboardGroup)

require(ParentParent.Configs.ConfigTypes)

local View = Foundation.View

local function KeyboardHelpPage() -- line: 18
	-- upvalues: useKeybinds (copy), React (copy), View (copy), KeyboardGroup (copy)
	local controls = useKeybinds().controls
	local groups = useKeybinds().groups
	local v11 = React.useMemo(function() -- line: 22
		-- upvalues: controls (copy), groups (copy), React (copy), View (copy), KeyboardGroup (copy)
		if controls == nil or groups == nil then
			return nil
		end

		local t1 = {}

		for _, v14 in groups do
			t1[v14.id] = {
				controls = {},
				group = v14
			}
		end

		for v15, v16 in controls do
			if v16.keyboardInput ~= nil then
				local group = v16.keyboardInput.group

				if t1[group.id] ~= nil then
					t1[group.id].controls[v15] = v16
				end
			end
		end

		local t2 = {}

		for _, v20 in t1 do
			if next(v20.controls) ~= nil then
				table.insert(t2, React.createElement(View, {
					tag = "auto-y padding-xxsmall",
					LayoutOrder = v20.group.layoutOrder,
					Size = UDim2.new(0.3333333333333333, -1, 0, 0),
					key = v20.group.id
				}, React.createElement(KeyboardGroup, v20)))
			end
		end

		return t2
	end, {
		controls,
		groups
	})

	if v11 == nil then
		return nil
	end

	return React.createElement(View, {
		tag = "row size-full-0 auto-y wrap align-x-left align-y-top"
	}, v11)
end

return React.memo(KeyboardHelpPage)
