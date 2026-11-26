local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("isDescendant")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")

local v6 = {}

local function getMemoKey(p2, p3)
	return `${p2}___${p3}`
end

local function getMemo(p2, p3, p4)
	local formatted = `${p3}___${p4}`

	return v6[p2][formatted]
end

local function setMemo(p2, p3, p4, p5)
	local formatted = `${p3}___${p4}`

	v6[p2][formatted] = p5
end

local function isDescendant(p2, p3, p4, p5)
	if not v6[p3] then
		v6[p3] = {}
	end

	local set = {}
	local function dfs(p6)
		set[p6] = true
		local formatted = `${p6}___${p5}`

		local v8 = v6[p3][formatted]

		if v8 ~= nil then
			return v8
		end

		local v9 = p2[p6]

		if v9 then
			if v9.children[p5] then
				local v10 = p3
				local formatted2 = `${p6}___${p5}`

				v6[v10][formatted2] = true

				return true
			else
				local filtered = Cryo.List.filter(
					Cryo.Dictionary.keys(v9.children),
					function(p7): boolean
						if set[p7] or not v9.children[p7] then
							return false
						end

						return true
					end
				)
				local v10 = false

				for k, v12 in filtered do
					if dfs(v12) then
						v10 = true
						break
					end
				end

				local v12 = p3
				local formatted2 = `${p6}___${p5}`

				v6[v12][formatted2] = v10

				return v10
			end
		else
			v5:error(`Node {p6} not found in graph`)
			local v10 = p3
			local formatted2 = `${p6}___${p5}`

			v6[v10][formatted2] = false

			return false
		end
	end

	return (dfs(p4))
end

return isDescendant
