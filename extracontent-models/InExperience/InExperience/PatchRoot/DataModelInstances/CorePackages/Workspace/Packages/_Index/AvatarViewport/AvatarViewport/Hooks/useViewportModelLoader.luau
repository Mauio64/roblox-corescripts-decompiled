local AvatarViewport = script:FindFirstAncestor("AvatarViewport")
local parent = AvatarViewport.Parent

local React = require(parent.React)

require(AvatarViewport.Types)

local function destroyLoadedModel(ref) -- 2 equivalent calls inferred from this helper
	local current = ref.current

	if current then
		current:Destroy()
		ref.current = nil
	end
end

local function useViewportModelLoader(data)
	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(nil)
	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(data.onModelReady)
	local ref4 = React.useRef(data.onLoadFailed)
	ref3.current = data.onModelReady
	ref4.current = data.onLoadFailed

	local v = React.useCallback(function(flag: boolean)
		local modelSource = data.modelSource
		ref.current += 1
		local current = ref.current

		if flag then
			setState(true)
		end

		setState2(false)
		setState3(nil)
		destroyLoadedModel(ref2) -- inferred equivalent call
		task.spawn(function()
			local function isCancelled(): boolean -- 1 equivalent call inferred from this helper
				return ref.current ~= current
			end

			local v = modelSource({ isCancelled = isCancelled })

			if isCancelled() then -- inferred equivalent call
				if v and v.model then
					v.model:Destroy()
				end
			elseif v then
				local current2 = data.worldModelRef.current

				if current2 then
					v.model.Parent = current2
					ref2.current = v.model
					setState3(v.model)
					setState2(true)

					if flag then
						setState(false)
					end

					if ref3.current then
						ref3.current(v)
					end
				else
					v.model:Destroy()

					if flag then
						setState(false)
					end
				end
			else
				if flag then
					setState(false)
				end

				if ref4.current then
					ref4.current()
				end
			end
		end)
	end, { data.modelSource, data.worldModelRef })

	React.useLayoutEffect(function()
		v(true)
		return function()
			ref.current += 1
			setState2(false)
			setState3(nil)
			destroyLoadedModel(ref2) -- inferred equivalent call
		end
	end, { v })

	return { isLoading = state, isReady = state2, model = state3 }
end

return useViewportModelLoader
