local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local React = require(ParentParentParent.React)
local RoactGamepad = require(ParentParentParent.RoactGamepad)
local useStyle = require(ParentParent.Core.Style.useStyle)
local CursorContext = require(script.Parent.CursorContext)
local CursorComponent = require(script.Parent.CursorComponent)
local CursorType = require(script.Parent.CursorType)

local function v12(s1: string) -- line: 24
	local n1 = 1e999
	local n2 = 1e999
	local n3 = 1e999
	local n4 = 1e999

	for v21, v22 in string.split(s1, " ") do
		local num = tonumber(v22)

		if num ~= nil then
			if v21 == 1 then
				n1 = num
			elseif v21 == 2 then
				n2 = num
			elseif v21 == 3 then
				n3 = num
			elseif v21 == 4 then
				n4 = num
			end
		end
	end

	assert(n1 ~= 1e999 and (n2 ~= 1e999 and (n3 ~= 1e999 and n4 ~= 1e999)), "Error! Not all parameters are decoded.")

	return UDim.new(n1, (math.max(0, n2 + n3))), n3, n4
end

return function(t1: {[any]: any}) -- line: 53
	-- upvalues: React (copy), RoactGamepad (copy), useStyle (copy), Cryo (copy), CursorType (copy), v12 (copy), CursorComponent (copy), CoreGui (copy), GuiService (copy), CursorContext (copy)
	local v25, v26 = React.useState({})
	local v27, v28 = React.useState({})
	local v29 = React.createRef()
	local v30, v31 = React.useState(nil)
	local v32 = RoactGamepad.useRefCache()
	local SelectionCursor = useStyle().Tokens.Component.SelectionCursor

	React.useEffect(function() -- line: 145
		-- upvalues: v29 (copy), CoreGui (copy), GuiService (copy), v31 (copy)
		if v29.current == nil or not v29.current:IsDescendantOf(game) then
			return
		end

		local v52 = v29.current:IsDescendantOf(CoreGui)

		local function setUpSelectionImageObjectConnection() -- line: 152
			-- upvalues: v52 (copy), GuiService (copy), v31 (copy)
			if v52 then
				return GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 157
					-- upvalues: GuiService (copy), v31 (copy)
					if GuiService.SelectedCoreObject == nil then
						v31(nil)

						return
					end

					v31(GuiService.SelectedCoreObject.SelectionImageObject)
				end)
			end

			return GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 165
				-- upvalues: GuiService (copy), v31 (copy)
				if GuiService.SelectedObject == nil then
					v31(nil)

					return
				end

				v31(GuiService.SelectedObject.SelectionImageObject)
			end)
		end

		local u54 = setUpSelectionImageObjectConnection()
		local connection = v29.current.AncestryChanged:Connect(function() -- line: 176
			-- upvalues: u54 (ref), setUpSelectionImageObjectConnection (copy)
			u54:Disconnect()
			u54 = setUpSelectionImageObjectConnection()
		end)

		return function() -- line: 186
			-- upvalues: u54 (ref), connection (copy)
			u54:Disconnect()
			connection:Disconnect()
		end
	end, {})

	return React.createElement(CursorContext.Provider, {
		value = {
			getCursor = function(uDim: UDim?, n5: number?, n6: number?) -- line: 61
				-- upvalues: SelectionCursor (copy), v25 (copy), v26 (copy), Cryo (copy), v32 (copy)
				warn("UIBlox's SelectionCursor is deprecated and should not be used anymore.")

				local uDim2 = UDim.new(0, 0)

				if uDim ~= nil then
					uDim2 = uDim
				end

				if n6 ~= nil then
					assert(n6 > 0, "Error! borderWidth should be larger than 0.")
				else
					n6 = SelectionCursor.BorderWidth
				end

				local v38 = if n5 == nil then SelectionCursor.Offset - n6 else n5 - n6
				local v39 = string.format("%f %f %f %f", uDim2.Scale, uDim2.Offset, v38, n6)

				if v25[v39] == nil then
					v26(Cryo.Dictionary.join(v25, {
						[v39] = true
					}))
				end

				return v32[v39]
			end,
			getCursorByType = function(p1) -- line: 96
				-- upvalues: CursorType (copy), v27 (copy), v28 (copy), Cryo (copy), v32 (copy)
				assert(CursorType.isEnumValue(p1), ("Error! expected a CursorType enum, got %s"):format((tostring(p1))))
				warn("UIBlox's SelectionCursor is deprecated and should not be used anymore.")

				if v27[p1] == nil then
					v28(Cryo.Dictionary.join(v27, {
						[p1] = true
					}))
				end

				return v32[p1]
			end
		}
	}, Cryo.Dictionary.join({
		InvisibleContainer = React.createElement("Frame", {
			Visible = false,
			Size = UDim2.new(0, 0, 0, 0),
			ref = v29
		}, ((function() -- line: 112
			-- upvalues: v25 (copy), v32 (copy), v30 (copy), v12 (copy), React (copy), CursorComponent (copy), v27 (copy)
			local t2 = {}

			for k, _ in pairs(v25) do
				local v44 = v32[k] ~= nil and (v30 ~= nil and v32[k].current == v30)
				local v45, v46, v47 = v12(k)

				t2[k] = React.createElement(CursorComponent, {
					ref = v32[k],
					isVisible = v44,
					cornerRadius = v45,
					offset = v46,
					borderWidth = v47
				})
			end

			for k, _ in pairs(v27) do
				local v50 = k.rawValue()
				local v51 = v32[k] ~= nil and (v30 ~= nil and v32[k].current == v30)

				t2[k] = React.createElement(v50, {
					ref = v32[k],
					isVisible = v51
				})
			end

			return t2
		end)()))
	}, t1.children))
end
