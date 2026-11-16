local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarViewport/React")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")

local function destroyLoadedModel(p2)
	local current = p2.current

	if current then
		current:Destroy()
		p2.current = nil
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

	local v5 = React.useCallback(function(p2)
		local modelSource = data.modelSource
		ref.current += 1
		local current = ref.current

		if p2 then
			setState(true)
		end

		setState2(false)
		setState3(nil)
		local v7 = ref2
		local current2 = v7.current

		if current2 then
			current2:Destroy()
			v7.current = nil
		end

		task.spawn(function()
			local v8 = modelSource({
				isCancelled = function(): boolean
					return ref.current ~= current
				end
			})

			if ref.current ~= current then
				if v8 and v8.model then
					v8.model:Destroy()
				end
			elseif v8 then
				local current3 = data.worldModelRef.current

				if current3 then
					v8.model.Parent = current3
					ref2.current = v8.model
					setState3(v8.model)
					setState2(true)

					if p2 then
						setState(false)
					end

					if ref3.current then
						ref3.current(v8)
					end
				else
					v8.model:Destroy()

					if p2 then
						setState(false)
					end
				end
			else
				if p2 then
					setState(false)
				end

				if ref4.current then
					ref4.current()
				end
			end
		end)
	end, { data.modelSource, data.worldModelRef })

	React.useLayoutEffect(function()
		v5(true)
		return function()
			ref.current += 1
			setState2(false)
			setState3(nil)
			local v7 = ref2
			local current = v7.current

			if current then
				current:Destroy()
				v7.current = nil
			end
		end
	end, { v5 })

	return { isLoading = state, isReady = state2, model = state3 }
end

return useViewportModelLoader
