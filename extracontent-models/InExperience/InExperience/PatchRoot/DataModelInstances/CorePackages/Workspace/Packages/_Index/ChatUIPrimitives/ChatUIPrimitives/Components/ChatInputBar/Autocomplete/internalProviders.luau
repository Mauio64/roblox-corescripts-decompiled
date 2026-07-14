local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Cryo = require(Parent.Cryo)
local EmojiList = require(Parent.EmojiList)
local Trie = require(script.Parent.Trie)

local function buildUnifiedTrie(t1: {[any]: any}?, b1: boolean?) -- line: 20
	-- upvalues: Trie (copy), Cryo (copy), EmojiList (copy)
	local v10 = Trie.new()

	if t1 then
		for _, v12 in t1 do
			v10:insert(v12:lower())
		end
	end

	if b1 then
		for _, v14 in Cryo.Dictionary.keys(EmojiList) do
			v10:insert(":" .. v14)
		end
	end

	return v10
end

return {
	buildTrie = buildUnifiedTrie,
	matchTrigger = function(s1: string, n1: number) -- line: 41
		if n1 < 2 then
			return nil
		end

		local n2 = 1

		for i = n1 - 1, 1, -1 do
			local v19 = string.sub(s1, i, i)

			if v19 == " " or v19 == "\n" then
				n2 = i + 1

				break
			end
		end

		local v20 = string.sub(s1, n2, n2)

		if v20 == "/" then
			if n2 ~= 1 then
				return nil
			end
		else
			if v20 ~= ":" then
				return nil
			end

			if n1 - n2 < 3 then
				return nil
			end
		end

		return {
			query = string.sub(s1, n2, n1 - 1),
			replaceStart = n2,
			replaceFinish = n1 - 1
		}
	end,
	search = function(p1, s2: string) -- line: 75
		-- upvalues: EmojiList (copy)
		local v23 = p1:autocomplete(s2:lower())

		table.sort(v23, function(s3: string, s4: string) -- line: 77
			-- upvalues: EmojiList (copy)
			local v31 = string.sub(s3, 1, 1) == ":"
			local v32 = string.sub(s4, 1, 1) == ":"

			if v31 and v32 then
				local popularity = EmojiList[string.sub(s3, 2)].popularity
				local popularity2 = EmojiList[string.sub(s4, 2)].popularity

				if popularity == popularity2 then
					return s3 < s4
				end

				return popularity < popularity2
			end

			return s3 < s4
		end)

		return v23
	end,
	formatReplacement = function(s5: string) -- line: 94
		-- upvalues: EmojiList (copy)
		if string.sub(s5, 1, 1) == ":" then
			return EmojiList[string.sub(s5, 2)].base
		end

		return s5
	end,
	renderEntry = function(s6: string, _: boolean) -- line: 101
		-- upvalues: EmojiList (copy), React (copy), Foundation (copy)
		if string.sub(s6, 1, 1) == ":" then
			local v27 = string.sub(s6, 2)
			local v28 = EmojiList[v27]

			return React.createElement(Foundation.View, {
				tag = "row align-y-center gap-large",
				Size = UDim2.fromScale(1, 1)
			}, {
				glyph = React.createElement(Foundation.Text, {
					tag = "auto-xy text-body-medium content-emphasis",
					LayoutOrder = 1,
					Text = not v28 and "" or v28.base
				}),
				name = React.createElement(Foundation.Text, {
					tag = "auto-xy text-body-medium content-emphasis",
					LayoutOrder = 2,
					Text = v27
				})
			})
		end

		return React.createElement(Foundation.Text, {
			tag = "text-body-medium text-align-x-left content-emphasis",
			Text = s6,
			Size = UDim2.fromScale(1, 1)
		})
	end
}
