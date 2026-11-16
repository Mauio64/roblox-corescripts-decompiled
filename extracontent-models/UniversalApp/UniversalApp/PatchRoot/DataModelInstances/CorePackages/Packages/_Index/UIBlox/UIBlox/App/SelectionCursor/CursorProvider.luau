local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local React = require(parent2.React)
local RoactGamepad = require(parent2.RoactGamepad)
local useStyle = require(parent.Core.Style.useStyle)

local CursorContext = require(script.Parent.CursorContext)
local CursorComponent = require(script.Parent.CursorComponent)
local CursorType = require(script.Parent.CursorType)

local function fn(value: string)
	local v = 1e999
	local v2 = 1e999
	local v3 = 1e999
	local v4 = 1e999

	for k, v5 in string.split(value, " ") do
		local v6 = tonumber(v5)

		if v6 == nil then
			continue
		end

		if k == 1 then
			v = v6
		elseif k == 2 then
			v2 = v6
		elseif k == 3 then
			v3 = v6
		elseif k == 4 then
			v4 = v6
		end
	end

	local v5 = v ~= 1e999 and v2 ~= 1e999 and v3 ~= 1e999 and v4 ~= 1e999
	assert(v5, "Error! Not all parameters are decoded.")

	return UDim.new(v, (math.max(0, v2 + v3))), v3, v4
end

local function fn2(udim: UDim, p: number, p2: number) -- 1 equivalent call inferred from this helper
	return string.format("%f %f %f %f", udim.Scale, udim.Offset, p, p2)
end

return function(p)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState({})
	local ref = React.createRef()
	local state3, setState3 = React.useState(nil)
	local v = RoactGamepad.useRefCache()
	local tokens = useStyle().Tokens

	local function fn3(udim: UDim?, p2: number?, p3: number?)
		warn("UIBlox's SelectionCursor is deprecated and should not be used anymore.")

		local v2 = UDim.new(0, 0)

		if udim ~= nil then
			v2 = udim
		end

		if p3 == nil then
			p3 = tokens.Stroke.Thick
		else
			assert(p3 > 0, "Error! borderWidth should be larger than 0.")
		end

		local v3

		if p2 == nil then
			v3 = tokens.Size.Size_150 - p3
		else
			v3 = p2 - p3
		end

		local v4 = fn2(v2, v3, p3) -- inferred equivalent call

		if state[v4] == nil then
			setState(Cryo.Dictionary.join(state, { [v4] = true }))
		end

		return v[v4]
	end

	local function fn4(p2)
		assert(CursorType.isEnumValue(p2), ("Error! expected a CursorType enum, got %s"):format((tostring(p2))))

		warn("UIBlox's SelectionCursor is deprecated and should not be used anymore.")

		if state2[p2] == nil then
			setState2(Cryo.Dictionary.join(state2, { [p2] = true }))
		end

		return v[p2]
	end

	local function fn5()
		local children = {}

		for k, _ in pairs(state) do
			local isVisible

			if v[k] == nil or state3 == nil then
				isVisible = false
			else
				isVisible = v[k].current == state3
			end

			local cornerRadius, offset, borderWidth = fn(k)

			children[k] = React.createElement(CursorComponent, {
				ref = v[k],
				isVisible = isVisible,
				cornerRadius = cornerRadius,
				offset = offset,
				borderWidth = borderWidth
			})
		end

		for k, _ in pairs(state2) do
			local rawValue = k.rawValue()
			local isVisible

			if v[k] == nil or state3 == nil then
				isVisible = false
			else
				isVisible = v[k].current == state3
			end

			children[k] = React.createElement(rawValue, { ref = v[k], isVisible = isVisible })
		end

		return children
	end

	React.useEffect(function()
		if ref.current == nil or not ref.current:IsDescendantOf(game) then
			return
		end

		local isDescendant = ref.current:IsDescendantOf(CoreGui)

		local function setUpSelectionImageObjectConnection()
			if isDescendant then
				return GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
					if GuiService.SelectedCoreObject == nil then
						setState3(nil)
					else
						setState3(GuiService.SelectedCoreObject.SelectionImageObject)
					end
				end)
			end

			return GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
				if GuiService.SelectedObject == nil then
					setState3(nil)
				else
					setState3(GuiService.SelectedObject.SelectionImageObject)
				end
			end)
		end

		local connection = setUpSelectionImageObjectConnection()
		local ancestryChangedConnection = ref.current.AncestryChanged:Connect(function()
			connection:Disconnect()
			connection = setUpSelectionImageObjectConnection()
		end)

		return function()
			connection:Disconnect()
			ancestryChangedConnection:Disconnect()
		end
	end, {})

	return React.createElement(CursorContext.Provider, {
		value = { getCursor = fn3, getCursorByType = fn4 }
	}, Cryo.Dictionary.join({
		InvisibleContainer = React.createElement(
			"Frame",
			{ Size = UDim2.new(0, 0, 0, 0), Visible = false, ref = ref },
			fn5()
		)
	}, p.children))
end
