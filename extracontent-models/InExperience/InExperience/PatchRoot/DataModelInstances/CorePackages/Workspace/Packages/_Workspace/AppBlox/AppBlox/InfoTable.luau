local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Foundation2 = require(parent.Foundation)
local useBreakpoint = Foundation2.Hooks.useBreakpoint
local Foundation3 = require(parent.Foundation)
local useResponsive = Foundation3.Hooks.useResponsive
local Foundation4 = require(parent.Foundation)
local ResponsiveProvider = Foundation4.ResponsiveProvider
local Cryo = require(parent.Cryo)

local SharedFlags = require(parent.SharedFlags)

local defineFastFlag = game:DefineFastFlag("LuaAppInfoTableResponsiveProviderOverride", false)
local FFlagInfoTableStableItemKeys = SharedFlags.FFlagInfoTableStableItemKeys

local Breakpoint = Foundation.Enums.Breakpoint

local function buildColumnMajorChildren(items, p: number, size: number)
	local count = #items
	local v = math.ceil(count / p)
	local count2 = 0
	local children = {}

	for i = 1, v do
		for j = 1, p do
			count2 += 1
			local v2 = (j - 1) * v + i
			local v3

			if v2 <= count then
				v3 = items[v2]
			else
				v3 = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y",
					BackgroundTransparency = 1
				})
			end

			local v4

			if FFlagInfoTableStableItemKeys then
				if v2 <= count then
					v4 = `Cell_{v2}`
				else
					v4 = `Placeholder_{count2}`
				end
			else
				v4 = `Cell_{count2}`
			end

			children[v4] = React.createElement(
				Foundation.Grid.Cell,
				{ size = size, tag = "size-full-0 auto-y", LayoutOrder = count2 },
				v3
			)
		end
	end

	return children
end

local function InfoTable(props)
	local v = not (props.numColumns and props.numColumns > 0) and 1 or props.numColumns
	local state, setState, state2, setState2

	if defineFastFlag then
		state, setState = React.useState(false)
		state2, setState2 = React.useState(nil)
	else
		setState = nil
	end

	local children = {}
	local size = 12 / v

	if not defineFastFlag or state then
		if v > 1 then
			children = buildColumnMajorChildren(props.items, v, size)
		else
			for k, item in props.items do
				children[`Cell_{k}`] = React.createElement(
					Foundation.Grid.Cell,
					{ size = size, tag = "size-full-0 auto-y", LayoutOrder = k },
					item
				)
			end
		end
	end

	local config

	if defineFastFlag then
		local v2 = useResponsive()
		config = Cryo.Dictionary.join(v2.config, {
			grid = Cryo.Dictionary.join(v2.config.grid, {
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

	if defineFastFlag then
		local _, v2 = useBreakpoint(state2)

		React.useEffect(function()
			if v2.X > 0 then
				task.defer(function()
					setState(true)
				end)
			end
		end, { v2.X })

		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = props.LayoutOrder,
			ref = setState2
		}, {
			ContentFrame = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = props.LayoutOrder
				},
				{
					Grid = React.createElement(
						ResponsiveProvider,
						{ config = config },
						React.createElement(
							Foundation.Grid.Root,
							{ tag = props.gridTag, testId = props.testId },
							children
						)
					)
				}
			)
		})
	elseif defineFastFlag then
		return React.createElement(
			ResponsiveProvider,
			{ config = config },
			React.createElement(
				Foundation.Grid.Root,
				{ tag = props.gridTag, LayoutOrder = props.LayoutOrder, testId = props.testId },
				children
			)
		)
	else
		return React.createElement(
			Foundation.Grid.Root,
			{ tag = props.gridTag, LayoutOrder = props.LayoutOrder, testId = props.testId },
			children
		)
	end
end

return React.memo(InfoTable)
