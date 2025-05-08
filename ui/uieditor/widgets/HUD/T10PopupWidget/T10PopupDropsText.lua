CoD.T10PopupDropsText = InheritFrom( LUI.UIElement )
CoD.T10PopupDropsText.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10PopupDropsText )
	self.id = "T10PopupDropsText"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.background = LUI.UIImage.new()
	self.background:setLeftRight( true, false, 772.5, 847.5 )
	self.background:setTopBottom( true, false, 454, 474.5 )
	self.background:setImage( RegisterImage( "blacktransparent" ) )
	self.background:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_nineslice_normal" ) )
	self.background:setShaderVector( 0, 0, 0, 0, 0 )
	self.background:setupNineSliceShader( 8, 8 )
	self.background:setAlpha( 0.1 )
	self:addElement( self.background )

	self.image = LUI.UIImage.new()
	self.image:setLeftRight( true, false, 751.5, 773 )
	self.image:setTopBottom( true, false, 453.5, 475 )
	self.image:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.image )

	self.text = LUI.UIText.new()
	self.text:setLeftRight( true, false, 772.5 - 100, 847.5 + 100 )
	self.text:setTopBottom( true, false, 454 - 8, 474.5 + 8 )
	self.text:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.text:setScale( 0.5 )
	self.text:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.text )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.background:close()
		element.image:close()
		element.text:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
