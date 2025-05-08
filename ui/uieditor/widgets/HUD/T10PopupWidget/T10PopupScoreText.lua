CoD.T10PopupScoreText = InheritFrom( LUI.UIElement )
CoD.T10PopupScoreText.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10PopupScoreText )
	self.id = "T10PopupScoreText"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.score = LUI.UIText.new()
	self.score:setLeftRight( true, true, 0, -323 )
	self.score:setTopBottom( true, false, 318 - 5, 354 + 5 )
	self.score:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.score:setScale( 0.5 )
	self.score:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self:addElement( self.score )

	self.name = LUI.UIText.new()
	self.name:setLeftRight( true, true, 536, 0 )
	self.name:setTopBottom( true, false, 318, 354 )
	self.name:setTTF( "fonts/noto_sans_cond_med.ttf" )
	self.name:setScale( 0.5 )
	self.name:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.name )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.score:close()
		element.name:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
