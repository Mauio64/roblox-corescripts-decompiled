local Parent = script:FindFirstAncestor("PlaceInfoRodux").Parent
local Promise = require(Parent.Promise)
local Http = require(Parent.Http)
local HttpRequest = require(Parent.HttpRequest)

require(Parent.LuauPolyfill)

local Url = Http.Url
local t1 = {}

t1.__index = t1

function t1.new(p1: ((...any) -> ...any)?) -- line: 59
	-- upvalues: HttpRequest (copy), t1 (copy)
	local t2 = {}
	local v9 = HttpRequest.config({
		requestFunction = function(s1: string, s2: string, t3: {[any]: any}?) -- line: 63
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s1, s2, t3)
		end
	})

	t2._placeInfo = {}
	t2._requestImpl = p1 or v9

	return (setmetatable(t2, t1))
end
function t1.name(t4: {[any]: any}, n1: number) -- line: 74
	return t4:_getInfo(n1, "name")
end
function t1.description(t5: {[any]: any}, n2: number) -- line: 78
	return t5:_getInfo(n2, "description")
end
function t1.universeId(t6: {[any]: any}, n3: number) -- line: 82
	return t6:_getInfo(n3, "universeId")
end
function t1._fetchPlacesInfo(t7: {[any]: any}, t8: {[any]: any}) -- line: 88
	-- upvalues: Url (copy)
	local t9 = {
		placeIds = t8
	}
	local v19 = Url:makeQueryString(t9)
	local v20 = string.format("%sv1/games/multiget-place-details?%s", Url.GAME_URL, v19)

	return t7._requestImpl(v20, "GET")
end
function t1.getPlacesInfo(t10: {[any]: any}, t11: {[any]: any}) -- line: 101
	-- upvalues: Promise (copy)
	local v23 = Promise.new(function(resolve, reject) -- line: 102
		-- upvalues: t10 (copy), t11 (copy)
		t10:_fetchPlacesInfo(t11):andThen(function(t12: {[any]: any}) -- line: 104
			-- upvalues: resolve (copy), t10 (copy)
			if not t12 or not t12.responseBody then
				resolve(nil)

				return
			end

			local t13 = {}

			for _, v41 in t12.responseBody do
				local t14 = {
					universeId = v41.universeId,
					name = v41.name,
					description = v41.description
				}

				t13[v41.placeId] = t14
				t10._placeInfo[v41.placeId] = t14
			end

			resolve(t13)
		end):catch(function(p2) -- line: 124
			-- upvalues: reject (copy)
			reject(p2)
		end)
	end)
	local t15 = {}

	for _, v26 in t11 do
		if t10._placeInfo[v26] then
			t15[v26] = Promise.resolve(t10._placeInfo[v26])
		else
			t10._placeInfo[v26] = v23:andThen(function(t16: {[any]: any}) -- line: 135
				-- upvalues: v26 (copy)
				return t16[v26]
			end)
			t15[v26] = t10._placeInfo[v26]
		end
	end

	return t15
end
function t1._getInfo(t17: {[any]: any}, n4: number, s3: string) -- line: 144
	-- upvalues: Promise (copy)
	if t17._placeInfo[n4] and t17._placeInfo[n4][s3] then
		return Promise.resolve(t17._placeInfo[n4][s3])
	end

	if t17._placeInfo[n4] then
		return t17._placeInfo[n4]:andThen(function(_: {[any]: any}) -- line: 151
			-- upvalues: t17 (copy), n4 (copy), s3 (copy)
			return t17._placeInfo[n4][s3]
		end)
	end

	return (t17:getPlacesInfo({ n4 })[n4]:andThen(function(t19: {[any]: any}) -- line: 156
		-- upvalues: s3 (copy)
		return t19[s3]
	end))
end

t1.default = t1.new()

return t1
