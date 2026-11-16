local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.BlockQuote)
require(CommonMark.node.BulletList)
require(CommonMark.node.Code)
require(CommonMark.node.CustomBlock)
require(CommonMark.node.CustomNode)
require(CommonMark.node.Document)
require(CommonMark.node.Emphasis)
require(CommonMark.node.FencedCodeBlock)
require(CommonMark.node.HardLineBreak)
require(CommonMark.node.Heading)
require(CommonMark.node.HtmlBlock)
require(CommonMark.node.HtmlInline)
require(CommonMark.node.Image)
require(CommonMark.node.IndentedCodeBlock)
require(CommonMark.node.Link)
require(CommonMark.node.LinkReferenceDefinition)
require(CommonMark.node.ListItem)
require(CommonMark.node.Node)
require(CommonMark.node.OrderedList)
require(CommonMark.node.Paragraph)
require(CommonMark.node.SoftLineBreak)
require(CommonMark.node.StrongEmphasis)
require(CommonMark.node.Text)
require(CommonMark.node.ThematicBreak)

local AbstractVisitor = {}
AbstractVisitor.__index = AbstractVisitor

function AbstractVisitor:visitBlockQuote(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitBulletList(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitCode(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitDocument(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitEmphasis(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitFencedCodeBlock(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitHardLineBreak(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitHeading(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitThematicBreak(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitHtmlInline(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitHtmlBlock(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitImage(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitIndentedCodeBlock(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitLink(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitListItem(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitOrderedList(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitParagraph(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitSoftLineBreak(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitStrongEmphasis(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitText(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitLinkReferenceDefinition(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitCustomBlock(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitCustomNode(p)
	self:visitChildren(p)
end

function AbstractVisitor:visitChildren(object)
	local v = object:getFirstChild()

	while v ~= nil do
		local nextNode = v:getNext()
		v:accept(self)
		v = nextNode
	end
end

return AbstractVisitor
