local Parent = script:FindFirstAncestor("BuildExperience").Parent

require(Parent.DataHydration.CreatorAgentChat)

return {
	awaitRequestState = function(p1, n1: number) -- line: 15
		while p1(false).status == "pending" do
			if n1 <= os.clock() then
				return p1(false)
			end

			task.wait()
		end

		return p1(false)
	end,
	getToolCallOrder = function(p2, s1: string) -- line: 26
		for v6, v7 in p2.activityItems do
			if v7.kind == "tool_call" and s1 == v7.toolCallId then
				return v6
			end
		end

		local t1 = {}

		for v9 in p2.toolCalls do
			table.insert(t1, v9)
		end

		table.sort(t1)

		for v10, v11 in t1 do
			if v11 == s1 then
				return v10
			end
		end

		return 0
	end
}
