local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)

local Cryo = require(parent.Cryo)

local v2 = {}

local function getMemoKey(p: string, p2: string) -- 2 equivalent calls inferred from this helper
	return `${p}___${p2}`
end

local function getMemo(p: string, p2: string, p3: string) -- 1 equivalent call inferred from this helper
	local memoKey = getMemoKey(p2, p3) -- inferred equivalent call
	return v2[p][memoKey]
end

local function setMemo(p: string, p2: string, p3: string, flag: boolean) -- 3 equivalent calls inferred from this helper
	local memoKey = getMemoKey(p2, p3) -- inferred equivalent call
	v2[p][memoKey] = flag
end

local function isDescendant(p, p2: string, p3: string, p4: string)
	if not v2[p2] then
		v2[p2] = {}
	end

	local set = {}
	local function dfs(p5: string)
		set[p5] = true
		local memo = getMemo(p2, p5, p4) -- inferred equivalent call

		if memo ~= nil then
			return memo
		end

		local v3 = p[p5]

		if v3 then
			if v3.children[p4] then
				setMemo(p2, p5, p4, true) -- inferred equivalent call
				return true
			else
				local filtered = Cryo.List.filter(Cryo.Dictionary.keys(v3.children), function(p6): boolean
					return not (set[p6] or not v3.children[p6])
				end)
				local v4 = false

				for _, v5 in filtered do
					if dfs(v5) then
						v4 = true
						break
					end
				end

				setMemo(p2, p5, p4, v4) -- inferred equivalent call
				return v4
			end
		else
			v:error(`Node {p5} not found in graph`)
			setMemo(p2, p5, p4, false) -- inferred equivalent call
			return false
		end
	end

	return (dfs(p3))
end

return isDescendant
