local Parent = script:FindFirstAncestor("PlaceInfoRodux").Parent
local Promise = require(Parent.Promise)
local Http = require(Parent.Http)
local HttpRequest = require(Parent.HttpRequest)

require(Parent.LuauPolyfill)

local Url = Http.Url
local t1 = {}

t1.__index = t1

function t1.new(p1: ((...any) -> ...any)?) -- line: 66
	-- upvalues: HttpRequest (copy), t1 (copy)
	local t2 = {}
	local v9 = HttpRequest.config({
		requestFunction = function(s1: string, s2: string, t3: {[any]: any}?) -- line: 70
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s1, s2, t3)
		end
	})

	t2._universeVotes = {}
	t2._requestImpl = p1 or v9

	return (setmetatable(t2, t1))
end
function t1.upVotes(t4: {[any]: any}, n1: number) -- line: 81
	return t4:_getVotes(n1, "upVotes")
end
function t1.downVotes(t5: {[any]: any}, n2: number) -- line: 85
	return t5:_getVotes(n2, "downVotes")
end
function t1.rating(t6: {[any]: any}, n3: number) -- line: 89
	return t6:_getVotes(n3, "rating")
end
function t1._fetchUniversesVotes(t7: {[any]: any}, t8: {[any]: any}) -- line: 95
	-- upvalues: Url (copy)
	local t9 = {
		universeIds = t8
	}
	local v19 = Url:makeQueryString(t9)
	local v20 = string.format("%sv1/games/votes?%s", Url.GAME_URL, v19)

	return t7._requestImpl(v20, "GET")
end
function t1.getUniversesVotes(t10: {[any]: any}, t11: {[any]: any}) -- line: 108
	-- upvalues: Promise (copy)
	local v23 = Promise.new(function(resolve, reject) -- line: 111
		-- upvalues: t10 (copy), t11 (copy)
		t10:_fetchUniversesVotes(t11):andThen(function(t12: {[any]: any}) -- line: 113
			-- upvalues: resolve (copy), t10 (copy)
			if not t12 or not t12.responseBody then
				resolve(nil)

				return
			end

			local t13 = {}

			for _, v41 in t12.responseBody.data do
				local v42 = if v41.upVotes + v41.downVotes ~= 0 then v41.upVotes / (v41.upVotes + v41.downVotes) else 0
				local t14 = {
					universeId = v41.id,
					upVotes = v41.upVotes,
					downVotes = v41.downVotes,
					rating = v42
				}

				t13[v41.id] = t14
				t10._universeVotes[v41.id] = t14
			end

			resolve(t13)
		end):catch(function(p2) -- line: 140
			-- upvalues: reject (copy)
			reject(p2)
		end)
	end)
	local t15 = {}

	for _, v26 in t11 do
		if t10._universeVotes[v26] then
			t15[v26] = Promise.resolve(t10._universeVotes[v26])
		else
			t10._universeVotes[v26] = v23:andThen(function(t16: {[any]: any}) -- line: 152
				-- upvalues: v26 (copy)
				return t16[v26]
			end)
			t15[v26] = t10._universeVotes[v26]
		end
	end

	return t15
end
function t1._getVotes(t17: {[any]: any}, n4: number, s3: string) -- line: 162
	-- upvalues: Promise (copy)
	if t17._universeVotes[n4] and t17._universeVotes[n4][s3] then
		return Promise.resolve(t17._universeVotes[n4][s3])
	end

	if t17._universeVotes[n4] then
		return t17._universeVotes[n4]:andThen(function(_: {[any]: any}) -- line: 169
			-- upvalues: t17 (copy), n4 (copy), s3 (copy)
			return t17._universeVotes[n4][s3]
		end)
	end

	return (t17:getUniversesVotes({ n4 })[n4]:andThen(function(t19: {[any]: any}) -- line: 174
		-- upvalues: s3 (copy)
		return t19[s3]
	end))
end

t1.default = t1.new()

return t1
