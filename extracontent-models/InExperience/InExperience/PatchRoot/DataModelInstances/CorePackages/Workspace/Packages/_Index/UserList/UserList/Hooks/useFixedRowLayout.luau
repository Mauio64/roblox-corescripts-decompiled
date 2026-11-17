local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Constants = require(UserList.Common.Constants)

local function useFixedRowLayout(flag: boolean, flag2: boolean)
	local v = Foundation.Hooks.useTokens()

	local length = Constants.USER_ROW_HEIGHT + 2 * v.Padding.Medium
	local state, setState = React.useState(0)

	local onHeaderSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize.Y)
	end, {})
	local v2 = not flag2 and 0 or state
	return React.useMemo(function()
		if flag then
			return {
				itemSize = UDim2.new(1, 0, 0, length),
				getItemLayout = function(_, p: number)
					return {
						length = length,
						offset = v2 + length * (p - 1),
						index = p
					}
				end,
				onHeaderSizeChanged = onHeaderSizeChanged
			}
		end

		return nil
	end, { flag, length, v2, onHeaderSizeChanged })
end

return useFixedRowLayout
