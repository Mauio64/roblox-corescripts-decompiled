local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Constants")

local function useFixedRowLayout(p2, p3)
	local v5 = Foundation.Hooks.useTokens()

	local v6 = Constants.USER_ROW_HEIGHT + 2 * v5.Padding.Medium
	local state, setState = React.useState(0)

	local v7 = React.useCallback(function(p4)
		setState(p4.AbsoluteSize.Y)
	end, {})
	local v8 = not p3 and 0 or state
	return React.useMemo(function()
		if p2 then
			return {
				itemSize = UDim2.new(1, 0, 0, v6),
				getItemLayout = function(p4, p5)
					return {
						length = v6,
						offset = v8 + v6 * (p5 - 1),
						index = p5
					}
				end,
				onHeaderSizeChanged = v7
			}
		end

		return nil
	end, { p2, v6, v8, v7 })
end

return useFixedRowLayout
