require( "ui.uieditor.widgets.HUD.T10PopupWidget.T10PopupDropsText" )

local DropsIcons = {
	Ammo = "hud_icon_br_ammo_arlmg",
	Armor = "ximage_c271d5876ed148",
	Salvage = "ui_icons_zombie_squad_info_salvage"
}

local PostLoadFunc = function ( self, controller, menu )
	self:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function ( model )
		local event = Engine.GetModelValue( model )

		if event == "drop_event" then
			local scriptNotifyData = CoD.GetScriptNotifyData( model )
			local name = Engine.Localize( Engine.GetIString( scriptNotifyData[1], "CS_LOCALIZED_STRINGS" ) )
			local score = scriptNotifyData[2]

			if name ~= nil and score ~= nil and type( score ) == "number" then
				-- Shift down existing texts
				for index = 3, 2, -1 do
					local prevImage = self["text" .. index - 1].image._imageName or "blacktransparent"
					local prevName = self["text" .. index - 1].text:getText() or ""

					-- Set background, image and text
					if prevName ~= "" then
						self["text" .. index].background:setImage( RegisterImage( "ui_icon_loot_backing" ) )
					end

					self["text" .. index].image:setImage( RegisterImage( prevImage ) )
					self["text" .. index].image._imageName = prevImage
					self["text" .. index].text:setText( tostring( prevName ) )
				end

				-- Set background, image and text
				self.text1.background:setImage( RegisterImage( "ui_icon_loot_backing" ) )
				for key, value in pairs( DropsIcons ) do
					if name:find( key ) then
						self.text1.image:setImage( RegisterImage( value ) )
						self.text1.image._imageName = value
					end
				end
				self.text1.text:setText( tostring( name ) .. " x" .. tostring( score ) )

				-- Fade out
				PlayClip( self, "PopupAnim", controller )

				-- Reset
				self:registerEventHandler( "clip_over", function ( element, event )
					for index = 1, 3 do
						self["text" .. index].background:setImage( RegisterImage( "blacktransparent" ) )
						self["text" .. index].image:setImage( RegisterImage( "blacktransparent" ) )
						self["text" .. index].image._imageName = "blacktransparent"
						self["text" .. index].text:setText( "" )
					end
				end )
			end
		end
	end )
end

CoD.T10PopupDrops = InheritFrom( LUI.UIElement )
CoD.T10PopupDrops.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10PopupDrops )
	self.id = "T10PopupDrops"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.text1 = CoD.T10PopupDropsText.new( menu, controller )
	self.text1:setLeftRight( true, true, 0, 0 )
	self.text1:setTopBottom( true, true, 0, 0 )
	self:addElement( self.text1 )

	self.text2 = CoD.T10PopupDropsText.new( menu, controller )
	self.text2:setLeftRight( true, true, 0, 0 )
	self.text2:setTopBottom( true, true, 30, 30 )
	self:addElement( self.text2 )
	
	self.text3 = CoD.T10PopupDropsText.new( menu, controller )
	self.text3:setLeftRight( true, true, 0, 0 )
	self.text3:setTopBottom( true, true, 60, 60 )
	self:addElement( self.text3 )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end,
			PopupAnim = function ()
				self:setupElementClipCounter( 3 )

				local PopupAnimFrame2 = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
					end
	
					element:setLeftRight( true, true, 200, 200 )
					element:setAlpha( 0 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				local PopupAnimFrame1 = function ( element, event )
					if event.interrupted then
						PopupAnimFrame2( element, event )

						return 
					else
						element:beginAnimation( "keyframe", 1500, false, false, CoD.TweenType.Linear )

						element:setAlpha( 1 )

						element:registerEventHandler( "transition_complete_keyframe", PopupAnimFrame2 )
					end
				end

				self.text1:completeAnimation()
				self.text1:setAlpha( 1 )
				self.text1:setLeftRight( true, true, 0, 0 )
				PopupAnimFrame1( self.text1, {} )
				
				self.text2:completeAnimation()
				self.text2:setAlpha( 1 )
				self.text2:setLeftRight( true, true, 0, 0 )
				PopupAnimFrame1( self.text2, {} )
				
				self.text3:completeAnimation()
				self.text3:setAlpha( 1 )
				self.text3:setLeftRight( true, true, 0, 0 )
				PopupAnimFrame1( self.text3, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.text1:close()
		element.text2:close()
		element.text3:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
