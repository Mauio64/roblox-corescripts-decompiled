local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
require(ViewRecyclerRoblox.Parent.ViewRecycler)

local CanvasItemPlacer = require(ViewRecyclerRoblox.RobloxAdapter.CanvasItemPlacer)
local EndLimitFrame = require(ViewRecyclerRoblox.RobloxAdapter.EndLimitFrame)
local HostPresentationPhase = require(ViewRecyclerRoblox.RobloxAdapter.HostPresentationPhase)

return {
	new = function(p, flag: boolean, callback)
		local v = {}

		local function releaseEndLimitFrame(p2) -- 3 equivalent calls inferred from this helper
			local endLimitFrame = p2.endLimitFrame

			if endLimitFrame ~= nil then
				p2.endLimitFrame = nil
				endLimitFrame.destroy()
			end
		end

		local function placeEndLimitFrame(p2, p3, p4, zIndex: number, originOffset: number?) -- 2 equivalent calls inferred from this helper
			local v2 = originOffset or 0
			p2.endLimitFrame.place(p4, p, (p3.mainAxisOffset or 0) + v2, p3.mainAxisEndLimit + v2, zIndex)

			p2.originOffset = originOffset
		end

		local function getGeometry(p2, p3, p4: number?) -- 2 equivalent calls inferred from this helper
			local state = p2.state
			return CanvasItemPlacer.getGeometry(
				state.itemLayout,
				p3,
				p,
				flag or state.index == nil,
				p4 == nil and 0 or state.contentStartOffset + p4,
				p2.geometry
			)
		end

		return {
			place = function(p2, placerState, p3, state, p4, p5)
				local v2

				if p4 then
					v2 = state.canvasPlacement
				else
					v2 = state.viewportPlacement
				end

				local v3 = v[p2]

				if v3 == nil then
					v3 = {
						placerState = placerState,
						state = state,
						geometry = {},
						originOffset = nil,
						endLimitFrame = nil
					}

					v[p2] = v3
				end

				v3.placerState = placerState
				v3.state = state
				local v4 = p5 ~= HostPresentationPhase.Hidden

				if v2.mainAxisEndLimit == nil then
					local originOffset

					if p4 then
						originOffset = callback()
					end

					CanvasItemPlacer.place(p2, p3, getGeometry(v3, v2, originOffset), placerState, v4) -- inferred equivalent call
					releaseEndLimitFrame(v3) -- inferred equivalent call
					v3.originOffset = originOffset

					return v4
				else
					local v5 = {
						mainAxisOffset = 0,
						mainAxisLength = v2.mainAxisLength,
						zIndex = v2.zIndex
					}
					local state2 = v3.state
					local geometry = CanvasItemPlacer.getGeometry(
						state2.itemLayout,
						v5,
						p,
						flag or state2.index == nil,
						0,
						v3.geometry
					)

					local endLimitFrame = v3.endLimitFrame or EndLimitFrame.new()
					v3.endLimitFrame = endLimitFrame
					CanvasItemPlacer.place(p2, endLimitFrame.instance, geometry, placerState, v4)

					local zIndex = p2.ZIndex
					local v6

					if p4 then
						v6 = callback()
					end

					placeEndLimitFrame(v3, v2, p3, zIndex, v6) -- inferred equivalent call
					return v4
				end
			end,
			remove = function(p2)
				local v2 = v[p2]

				if v2 ~= nil then
					v[p2] = nil

					if FFlagViewRecyclerReact084 then
						local endLimitFrame = v2.endLimitFrame

						if endLimitFrame ~= nil and p2.Parent == endLimitFrame.instance then
							p2.Parent = endLimitFrame.instance.Parent
						end
					end

					releaseEndLimitFrame(v2) -- inferred equivalent call
				end
			end,
			setConfiguration = function(p2, p3)
				p = p2
				flag = p3
			end,
			setOriginOffset = function(originOffset)
				for k, v2 in v do
					if not (v2.originOffset ~= nil and v2.originOffset ~= originOffset) then
						continue
					end

					local endLimitFrame = v2.endLimitFrame

					if endLimitFrame == nil then
						local geometry = getGeometry(v2, v2.state.canvasPlacement, originOffset) -- inferred equivalent call
						CanvasItemPlacer.updatePosition(k, geometry, v2.placerState)
						v2.originOffset = originOffset
					else
						placeEndLimitFrame( -- inferred equivalent call
							v2,
							v2.state.canvasPlacement,
							endLimitFrame.instance.Parent,
							k.ZIndex,
							originOffset
						)
					end
				end
			end,
			destroy = function()
				for _, v2 in v do
					releaseEndLimitFrame(v2) -- inferred equivalent call
				end

				table.clear(v)
			end
		}
	end
}
