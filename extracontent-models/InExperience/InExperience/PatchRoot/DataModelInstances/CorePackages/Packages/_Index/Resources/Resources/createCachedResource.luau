require(script.Parent.types)

local function once(disposeResource) -- 1 equivalent call inferred from this helper
	local v = false
	local function notAgain()
		if not v then
			v = true
			disposeResource()
		end
	end
	return notAgain
end

local function createCachedResource(callback)
	local v = nil
	local v2 = nil
	local v3 = 0

	local function disposeResource() -- 1 equivalent call inferred from this helper
		v3 -= 1

		if v3 == 0 then
			v = nil

			if v2 ~= nil then
				local v4 = v2
				v2 = nil
				v4()
			end
		end
	end

	local function constructResource()
		v2, v = callback()
	end

	local function handleError(flag: boolean, ...)
		if not flag then
			disposeResource() -- inferred equivalent call
			error(...)
		end
	end

	local function cachedResource()
		v3 += 1

		if v3 == 1 then
			handleError(pcall(constructResource))
		end

		return once(disposeResource), v -- inferred equivalent call
	end

	return cachedResource
end

return createCachedResource
