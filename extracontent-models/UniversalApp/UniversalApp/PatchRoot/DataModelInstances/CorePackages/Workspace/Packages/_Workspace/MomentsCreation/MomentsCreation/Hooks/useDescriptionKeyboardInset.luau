local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local React = require(MomentsCreationParent.React)
local UserInputService = game:GetService("UserInputService")
local computeKeyboardInset = require(MomentsCreation.Utils.computeKeyboardInset)
local GetFFlagMomentsDescriptionKeyboardAvoidanceFix = require(MomentsCreation.Flags.GetFFlagMomentsDescriptionKeyboardAvoidanceFix)

local function useDescriptionKeyboardInset(b1: boolean) -- line: 33
	-- upvalues: GetFFlagMomentsDescriptionKeyboardAvoidanceFix (copy), React (copy), computeKeyboardInset (copy), UserInputService (copy)
	local v9 = GetFFlagMomentsDescriptionKeyboardAvoidanceFix()
	local v10, v11 = React.useBinding(0)
	local v12, v13 = React.useState(0)
	local v14 = React.useRef(nil)
	local v15 = React.useCallback(function() -- line: 42
		-- upvalues: v14 (copy), computeKeyboardInset (copy), b1 (copy), UserInputService (copy), v9 (copy), v11 (copy), v13 (copy)
		local current = v14.current
		local v18 = current == nil and 0 or current.AbsolutePosition.Y + current.AbsoluteSize.Y
		local v19 = computeKeyboardInset(b1, UserInputService.OnScreenKeyboardVisible, UserInputService.OnScreenKeyboardPosition.Y, v18, not v9 and 1e999 or UserInputService.OnScreenKeyboardSize.Y)

		if v9 then
			v11(v19)

			return
		end

		v13(v19)
	end, {
		b1,
		v9
	})
	local v16 = React.useCallback(function(p1) -- line: 63
		-- upvalues: v14 (copy), v15 (copy)
		v14.current = p1
		v15()
	end, { v15 })

	React.useEffect(function() -- line: 68
		-- upvalues: v15 (copy), b1 (copy), UserInputService (copy)
		v15()

		if not b1 then
			return
		end

		local t1 = {
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v15),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v15),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v15)
		}

		return function() -- line: 80
			-- upvalues: t1 (copy)
			for _, v23 in t1 do
				v23:Disconnect()
			end
		end
	end, {
		b1,
		v15
	})

	return if not v9 then v12 else v10, v16
end

return useDescriptionKeyboardInset
