local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useBreakpoint = require(Parent.Foundation).Hooks.useBreakpoint
local useResponsive = require(Parent.Foundation).Hooks.useResponsive
local ResponsiveProvider = require(Parent.Foundation).ResponsiveProvider
local Cryo = require(Parent.Cryo)
local v8 = game:DefineFastFlag("LuaAppInfoTableResponsiveProviderOverride", false)
local v9 = game:DefineFastFlag("LuaAppInfoTableWorkaroundGridJank2", false) and v8
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport
local Breakpoint = Foundation.Enums.Breakpoint

local function buildColumnMajorChildren(t1: {[any]: any}, n1: number, n2: number) -- line: 27
	-- upvalues: React (copy), Foundation (copy)
	local v17 = #t1
	local v18 = math.ceil(v17 / n1)
	local t2 = {}
	local n3 = 0

	for i = 1, v18 do
		for j = 1, n1 do
			n3 += 1

			local v23 = (j - 1) * v18 + i
			local v24 = if not (v23 <= v17) then React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				BackgroundTransparency = 1
			}) else t1[v23]

			t2[`Cell_{ n3 }`] = React.createElement(Foundation.Grid.Cell, {
				tag = "size-full-0 auto-y",
				size = n2,
				LayoutOrder = n3
			}, v24)
		end
	end

	return t2
end
local function InfoTable(t3: {[any]: any}) -- line: 75
	-- upvalues: v9 (copy), React (copy), FFlagSduiExperienceDetailsSupport (copy), buildColumnMajorChildren (copy), Foundation (copy), v8 (copy), useResponsive (copy), Cryo (copy), Breakpoint (copy), useBreakpoint (copy), ResponsiveProvider (copy)
	local v26 = (not t3.numColumns or not (t3.numColumns > 0)) and 1 or t3.numColumns
	local v27 = nil
	local u28 = nil
	local v29 = nil
	local v30 = nil

	if v9 then
		local v31

		v27, v31 = React.useState(false)
		u28 = v31
		v29, v30 = React.useState(nil)
	end

	local t4 = {}
	local v33 = 12 / v26

	if not v9 or v27 then
		if FFlagSduiExperienceDetailsSupport and v26 > 1 then
			t4 = buildColumnMajorChildren(t3.items, v26, v33)
		else
			for v34, v35 in t3.items do
				t4[`Cell_{ v34 }`] = React.createElement(Foundation.Grid.Cell, {
					tag = "size-full-0 auto-y",
					size = v33,
					LayoutOrder = v34
				}, v35)
			end
		end
	end

	local v36 = nil

	if v8 then
		local v37 = useResponsive()

		v36 = Cryo.Dictionary.join(v37.config, {
			grid = Cryo.Dictionary.join(v37.config.grid, {
				margins = {
					[Breakpoint.XSmall] = 0,
					[Breakpoint.Small] = 0,
					[Breakpoint.Medium] = 0,
					[Breakpoint.Large] = 0,
					[Breakpoint.XLarge] = 0,
					[Breakpoint.XXLarge] = 0
				}
			})
		})
	end

	if v9 then
		local _, v39 = useBreakpoint(v29)

		React.useEffect(function() -- line: 120
			-- upvalues: v39 (copy), u28 (ref)
			if v39.X > 0 then
				task.defer(function() -- line: 122
					-- upvalues: u28 (ref)
					u28(true)
				end)
			end
		end, { v39.X })

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = t3.LayoutOrder,
			ref = v30
		}, {
			ContentFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = t3.LayoutOrder
			}, {
				Grid = React.createElement(ResponsiveProvider, {
					config = v36
				}, React.createElement(Foundation.Grid.Root, {
					tag = t3.gridTag,
					testId = t3.testId
				}, t4))
			})
		})
	end

	if v8 then
		return React.createElement(ResponsiveProvider, {
			config = v36
		}, React.createElement(Foundation.Grid.Root, {
			tag = t3.gridTag,
			LayoutOrder = t3.LayoutOrder,
			testId = t3.testId
		}, t4))
	end

	return React.createElement(Foundation.Grid.Root, {
		tag = t3.gridTag,
		LayoutOrder = t3.LayoutOrder,
		testId = t3.testId
	}, t4)
end

return React.memo(InfoTable)
