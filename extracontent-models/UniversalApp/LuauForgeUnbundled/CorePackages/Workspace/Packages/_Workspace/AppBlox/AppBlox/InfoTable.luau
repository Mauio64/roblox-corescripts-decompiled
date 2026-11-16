local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local useBreakpoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation").Hooks.useBreakpoint
local useResponsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation").Hooks.useResponsive
local responsiveProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation").ResponsiveProvider
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")

local defineFastFlag = game:DefineFastFlag("LuaAppInfoTableResponsiveProviderOverride", false)
local fFlagInfoTableStableItemKeys = SharedFlags.FFlagInfoTableStableItemKeys

local breakpoint = Foundation.Enums.Breakpoint

local function buildColumnMajorChildren(items, p2, p3)
	local count = #items
	local v5 = math.ceil(count / p2)
	local count2 = 0
	local children = {}

	for i = 1, v5 do
		for j = 1, p2 do
			count2 += 1
			local v6 = (j - 1) * v5 + i
			local v7

			if v6 <= count then
				v7 = items[v6]
			else
				v7 = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y",
					BackgroundTransparency = 1
				})
			end

			local v8

			if fFlagInfoTableStableItemKeys then
				v8 = if v6 <= count then `Cell_{v6}` else `Placeholder_{count2}`
			else
				v8 = `Cell_{count2}`
			end

			children[v8] = React.createElement(
				Foundation.Grid.Cell,
				{ size = p3, tag = "size-full-0 auto-y", LayoutOrder = count2 },
				v7
			)
		end
	end

	return children
end

local function InfoTable(props)
	local v5 = not (props.numColumns and props.numColumns > 0) and 1 or props.numColumns
	local state, setState, state2, setState2

	if defineFastFlag then
		state, setState = React.useState(false)
		state2, setState2 = React.useState(nil)
	else
		setState = nil
	end

	local children = {}
	local v6 = 12 / v5

	if not defineFastFlag or state then
		if v5 > 1 then
			children = buildColumnMajorChildren(props.items, v5, v6)
		else
			for k, item in props.items do
				children[`Cell_{k}`] = React.createElement(
					Foundation.Grid.Cell,
					{ size = v6, tag = "size-full-0 auto-y", LayoutOrder = k },
					item
				)
			end
		end
	end

	local v7

	if defineFastFlag then
		local v8 = useResponsive()
		v7 = Cryo.Dictionary.join(v8.config, {
			grid = Cryo.Dictionary.join(v8.config.grid, {
				margins = {
					[breakpoint.XSmall] = 0,
					[breakpoint.Small] = 0,
					[breakpoint.Medium] = 0,
					[breakpoint.Large] = 0,
					[breakpoint.XLarge] = 0,
					[breakpoint.XXLarge] = 0
				}
			})
		})
	end

	if defineFastFlag then
		local v8, v9 = useBreakpoint(state2)

		React.useEffect(function()
			if v9.X > 0 then
				task.defer(function()
					setState(true)
				end)
			end
		end, { v9.X })

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
						responsiveProvider,
						{ config = v7 },
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
			responsiveProvider,
			{ config = v7 },
			React.createElement(
				Foundation.Grid.Root,
				{
					tag = props.gridTag,
					LayoutOrder = props.LayoutOrder,
					testId = props.testId
				},
				children
			)
		)
	else
		return React.createElement(
			Foundation.Grid.Root,
			{
				tag = props.gridTag,
				LayoutOrder = props.LayoutOrder,
				testId = props.testId
			},
			children
		)
	end
end

return React.memo(InfoTable)
