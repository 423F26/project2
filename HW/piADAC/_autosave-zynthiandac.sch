(kicad_sch
	(version 20250114)
	(generator "eeschema")
	(generator_version "9.0")
	(uuid "344cfa04-e666-4c5f-9953-672189c8ae7e")
	(paper "A3")
	(lib_symbols
		(symbol "Connector:AudioJack2_Ground"
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "J"
				(at 0 8.89 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Value" "Connector_AudioJack2_Ground"
				(at 0 6.35 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Footprint" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "Jack*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "AudioJack2_Ground_0_1"
				(rectangle
					(start -2.54 -2.54)
					(end -3.81 0)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type outline)
					)
				)
				(polyline
					(pts
						(xy 0 0) (xy 0.635 -0.635) (xy 1.27 0) (xy 2.54 0)
					)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 2.54 3.81)
					(end -2.54 -2.54)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type background)
					)
				)
				(polyline
					(pts
						(xy 2.54 2.54) (xy -0.635 2.54) (xy -0.635 0) (xy -1.27 -0.635) (xy -1.905 0)
					)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type none)
					)
				)
			)
			(symbol "AudioJack2_Ground_1_1"
				(pin passive line
					(at 0 -5.08 90)
					(length 2.54)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "G"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 5.08 2.54 180)
					(length 2.54)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "S"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 5.08 0 180)
					(length 2.54)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "T"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "Connector:AudioJack2_Ground_Switch"
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "J"
				(at 0 11.43 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Value" "Connector_AudioJack2_Ground_Switch"
				(at 0 8.89 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Footprint" ""
				(at 0 5.08 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" ""
				(at 0 5.08 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "Jack*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "AudioJack2_Ground_Switch_0_1"
				(rectangle
					(start -2.54 -2.54)
					(end -3.81 0)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type outline)
					)
				)
				(rectangle
					(start 2.54 6.35)
					(end -2.54 -5.08)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type background)
					)
				)
			)
			(symbol "AudioJack2_Ground_Switch_1_1"
				(polyline
					(pts
						(xy 0 0) (xy 0.635 -0.635) (xy 1.27 0) (xy 2.54 0)
					)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 0.635 4.826) (xy 0.889 4.318)
					)
					(stroke
						(width 0)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 1.778 -0.254) (xy 2.032 -0.762)
					)
					(stroke
						(width 0)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 2.54 5.08) (xy -0.635 5.08) (xy -0.635 0) (xy -1.27 -0.635) (xy -1.905 0)
					)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 2.54 2.54) (xy 0.635 2.54) (xy 0.635 4.826) (xy 0.381 4.318)
					)
					(stroke
						(width 0)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 2.54 -2.54) (xy 1.778 -2.54) (xy 1.778 -0.254) (xy 1.524 -0.762)
					)
					(stroke
						(width 0)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(pin passive line
					(at 0 -7.62 90)
					(length 2.54)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "G"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 5.08 5.08 180)
					(length 2.54)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "S"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 5.08 2.54 180)
					(length 2.54)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "SN"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 5.08 0 180)
					(length 2.54)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "T"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 5.08 -2.54 180)
					(length 2.54)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "TN"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "Connector_Generic:Conn_02x10_Odd_Even"
			(pin_names
				(offset 1.016)
				(hide yes)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "J"
				(at 1.27 12.7 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Value" "Conn_02x10_Odd_Even"
				(at 1.27 -15.24 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Footprint" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" "~"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" "Generic connector, double row, 02x10, odd/even pin numbering scheme (row 1 odd numbers, row 2 even numbers), script generated (kicad-library-utils/schlib/autogen/connector/)"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "connector"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "Connector*:*_2x??_*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "Conn_02x10_Odd_Even_1_1"
				(rectangle
					(start -1.27 11.43)
					(end 3.81 -13.97)
					(stroke
						(width 0.254)
						(type default)
					)
					(fill
						(type background)
					)
				)
				(rectangle
					(start -1.27 10.287)
					(end 0 10.033)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 7.747)
					(end 0 7.493)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 5.207)
					(end 0 4.953)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 2.667)
					(end 0 2.413)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 0.127)
					(end 0 -0.127)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -2.413)
					(end 0 -2.667)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -4.953)
					(end 0 -5.207)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -7.493)
					(end 0 -7.747)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -10.033)
					(end 0 -10.287)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -12.573)
					(end 0 -12.827)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 10.287)
					(end 2.54 10.033)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 7.747)
					(end 2.54 7.493)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 5.207)
					(end 2.54 4.953)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 2.667)
					(end 2.54 2.413)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 0.127)
					(end 2.54 -0.127)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -2.413)
					(end 2.54 -2.667)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -4.953)
					(end 2.54 -5.207)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -7.493)
					(end 2.54 -7.747)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -10.033)
					(end 2.54 -10.287)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -12.573)
					(end 2.54 -12.827)
					(stroke
						(width 0.1524)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(pin passive line
					(at -5.08 10.16 0)
					(length 3.81)
					(name "Pin_1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 7.62 0)
					(length 3.81)
					(name "Pin_3"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "3"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 5.08 0)
					(length 3.81)
					(name "Pin_5"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "5"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 2.54 0)
					(length 3.81)
					(name "Pin_7"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "7"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 0 0)
					(length 3.81)
					(name "Pin_9"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "9"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -2.54 0)
					(length 3.81)
					(name "Pin_11"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "11"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -5.08 0)
					(length 3.81)
					(name "Pin_13"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "13"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -7.62 0)
					(length 3.81)
					(name "Pin_15"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "15"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -10.16 0)
					(length 3.81)
					(name "Pin_17"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "17"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -12.7 0)
					(length 3.81)
					(name "Pin_19"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "19"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 10.16 180)
					(length 3.81)
					(name "Pin_2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 7.62 180)
					(length 3.81)
					(name "Pin_4"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "4"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 5.08 180)
					(length 3.81)
					(name "Pin_6"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "6"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 2.54 180)
					(length 3.81)
					(name "Pin_8"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "8"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 0 180)
					(length 3.81)
					(name "Pin_10"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "10"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -2.54 180)
					(length 3.81)
					(name "Pin_12"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "12"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -5.08 180)
					(length 3.81)
					(name "Pin_14"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "14"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -7.62 180)
					(length 3.81)
					(name "Pin_16"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "16"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -10.16 180)
					(length 3.81)
					(name "Pin_18"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "18"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -12.7 180)
					(length 3.81)
					(name "Pin_20"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "20"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "Device:C"
			(pin_numbers
				(hide yes)
			)
			(pin_names
				(offset 0.254)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "C"
				(at 0.635 2.54 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(justify left)
				)
			)
			(property "Value" "C"
				(at 0.635 -2.54 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(justify left)
				)
			)
			(property "Footprint" ""
				(at 0.9652 -3.81 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" "~"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" "Unpolarized capacitor"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "cap capacitor"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "C_*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "C_0_1"
				(polyline
					(pts
						(xy -2.032 0.762) (xy 2.032 0.762)
					)
					(stroke
						(width 0.508)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy -2.032 -0.762) (xy 2.032 -0.762)
					)
					(stroke
						(width 0.508)
						(type default)
					)
					(fill
						(type none)
					)
				)
			)
			(symbol "C_1_1"
				(pin passive line
					(at 0 3.81 270)
					(length 2.794)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 0 -3.81 90)
					(length 2.794)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "Device:LED"
			(pin_numbers
				(hide yes)
			)
			(pin_names
				(offset 1.016)
				(hide yes)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "D"
				(at 0 2.54 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Value" "LED"
				(at 0 -2.54 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Footprint" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" "~"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" "Light emitting diode"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Sim.Pins" "1=K 2=A"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "LED diode"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "LED* LED_SMD:* LED_THT:*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "LED_0_1"
				(polyline
					(pts
						(xy -3.048 -0.762) (xy -4.572 -2.286) (xy -3.81 -2.286) (xy -4.572 -2.286) (xy -4.572 -1.524)
					)
					(stroke
						(width 0)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy -1.778 -0.762) (xy -3.302 -2.286) (xy -2.54 -2.286) (xy -3.302 -2.286) (xy -3.302 -1.524)
					)
					(stroke
						(width 0)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy -1.27 0) (xy 1.27 0)
					)
					(stroke
						(width 0)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy -1.27 -1.27) (xy -1.27 1.27)
					)
					(stroke
						(width 0.254)
						(type default)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 1.27 -1.27) (xy 1.27 1.27) (xy -1.27 0) (xy 1.27 -1.27)
					)
					(stroke
						(width 0.254)
						(type default)
					)
					(fill
						(type none)
					)
				)
			)
			(symbol "LED_1_1"
				(pin passive line
					(at -3.81 0 0)
					(length 2.54)
					(name "K"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 3.81 0 180)
					(length 2.54)
					(name "A"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "Device:R"
			(pin_numbers
				(hide yes)
			)
			(pin_names
				(offset 0)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "R"
				(at 2.032 0 90)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Value" "R"
				(at 0 0 90)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Footprint" ""
				(at -1.778 0 90)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" "~"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" "Resistor"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "R res resistor"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "R_*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "R_0_1"
				(rectangle
					(start -1.016 -2.54)
					(end 1.016 2.54)
					(stroke
						(width 0.254)
						(type default)
					)
					(fill
						(type none)
					)
				)
			)
			(symbol "R_1_1"
				(pin passive line
					(at 0 3.81 270)
					(length 1.27)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 0 -3.81 90)
					(length 1.27)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "Memory_EEPROM:AT24CS01-STUM"
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "U"
				(at -7.62 6.35 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Value" "AT24CS01-STUM"
				(at 2.54 -6.35 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(justify left)
				)
			)
			(property "Footprint" "Package_TO_SOT_SMD:SOT-23-5"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" "http://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-8815-SEEPROM-AT24CS01-02-Datasheet.pdf"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" "I2C Serial EEPROM, 1Kb (128x8) with Unique Serial Number, SOT-23-5"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "I2C Serial EEPROM Nonvolatile Memory"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "SOT?23*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "AT24CS01-STUM_1_1"
				(rectangle
					(start -7.62 5.08)
					(end 7.62 -5.08)
					(stroke
						(width 0.254)
						(type default)
					)
					(fill
						(type background)
					)
				)
				(pin power_in line
					(at 0 7.62 270)
					(length 2.54)
					(name "VCC"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "4"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -7.62 90)
					(length 2.54)
					(name "GND"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin bidirectional line
					(at 10.16 2.54 180)
					(length 2.54)
					(name "SDA"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "3"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin input line
					(at 10.16 0 180)
					(length 2.54)
					(name "SCL"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin input line
					(at 10.16 -2.54 180)
					(length 2.54)
					(name "WP"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "5"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "conn_02x20:Conn_2x20"
			(pin_numbers
				(hide yes)
			)
			(pin_names
				(offset 0)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "J"
				(at 1.27 25.4 0)
				(effects
					(font
						(size 0.508 0.508)
					)
					(hide yes)
				)
			)
			(property "Value" "Conn_2x20"
				(at 1.27 -27.94 0)
				(effects
					(font
						(size 0.9906 0.9906)
					)
				)
			)
			(property "Footprint" ""
				(at 0 0 0)
				(effects
					(font
						(size 0.508 0.508)
					)
					(hide yes)
				)
			)
			(property "Datasheet" "~"
				(at 0 0 0)
				(effects
					(font
						(size 0.508 0.508)
					)
					(hide yes)
				)
			)
			(property "Description" "Raspberry pi connector, double row, 02x20"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "connector"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "Connector*:*_2x??_*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "Conn_2x20_1_1"
				(rectangle
					(start -1.27 24.13)
					(end 3.81 -26.67)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type background)
					)
				)
				(rectangle
					(start -1.27 22.987)
					(end 0 22.733)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 20.447)
					(end 0 20.193)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 17.907)
					(end 0 17.653)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 15.367)
					(end 0 15.113)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 12.827)
					(end 0 12.573)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 10.287)
					(end 0 10.033)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 7.747)
					(end 0 7.493)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 5.207)
					(end 0 4.953)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 2.667)
					(end 0 2.413)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 0.127)
					(end 0 -0.127)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -2.413)
					(end 0 -2.667)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -4.953)
					(end 0 -5.207)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -7.493)
					(end 0 -7.747)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -10.033)
					(end 0 -10.287)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -12.573)
					(end 0 -12.827)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -15.113)
					(end 0 -15.367)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -17.653)
					(end 0 -17.907)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -20.193)
					(end 0 -20.447)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -22.733)
					(end 0 -22.987)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start -1.27 -25.273)
					(end 0 -25.527)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 22.987)
					(end 2.54 22.733)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 20.447)
					(end 2.54 20.193)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 17.907)
					(end 2.54 17.653)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 15.367)
					(end 2.54 15.113)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 12.827)
					(end 2.54 12.573)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 10.287)
					(end 2.54 10.033)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 7.747)
					(end 2.54 7.493)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 5.207)
					(end 2.54 4.953)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 2.667)
					(end 2.54 2.413)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 0.127)
					(end 2.54 -0.127)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -2.413)
					(end 2.54 -2.667)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -4.953)
					(end 2.54 -5.207)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -7.493)
					(end 2.54 -7.747)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -10.033)
					(end 2.54 -10.287)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -12.573)
					(end 2.54 -12.827)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -15.113)
					(end 2.54 -15.367)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -17.653)
					(end 2.54 -17.907)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -20.193)
					(end 2.54 -20.447)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -22.733)
					(end 2.54 -22.987)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(rectangle
					(start 3.81 -25.273)
					(end 2.54 -25.527)
					(stroke
						(width 0.1524)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(pin passive line
					(at -5.08 22.86 0)
					(length 3.81)
					(name "dc_3.3v"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 20.32 0)
					(length 3.81)
					(name "sda1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "3"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 17.78 0)
					(length 3.81)
					(name "scl1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "5"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 15.24 0)
					(length 3.81)
					(name "p04"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "7"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 12.7 0)
					(length 3.81)
					(name "gnd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "9"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 10.16 0)
					(length 3.81)
					(name "p17"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "11"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 7.62 0)
					(length 3.81)
					(name "p27"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "13"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 5.08 0)
					(length 3.81)
					(name "p22"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "15"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 2.54 0)
					(length 3.81)
					(name "dc_3.3v"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "17"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 0 0)
					(length 3.81)
					(name "p10"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "19"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -2.54 0)
					(length 3.81)
					(name "p9"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "21"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -5.08 0)
					(length 3.81)
					(name "p11"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "23"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -7.62 0)
					(length 3.81)
					(name "gnd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "25"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -10.16 0)
					(length 3.81)
					(name "id_sd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "27"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -12.7 0)
					(length 3.81)
					(name "p05"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "29"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -15.24 0)
					(length 3.81)
					(name "p06"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "31"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -17.78 0)
					(length 3.81)
					(name "p13"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "33"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -20.32 0)
					(length 3.81)
					(name "p19"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "35"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -22.86 0)
					(length 3.81)
					(name "p26"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "37"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 -25.4 0)
					(length 3.81)
					(name "gnd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "39"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 22.86 180)
					(length 3.81)
					(name "dc_5v"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 20.32 180)
					(length 3.81)
					(name "dc_5v"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "4"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 17.78 180)
					(length 3.81)
					(name "gnd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "6"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 15.24 180)
					(length 3.81)
					(name "txd0"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "8"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 12.7 180)
					(length 3.81)
					(name "rxd0"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "10"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 10.16 180)
					(length 3.81)
					(name "p18"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "12"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 7.62 180)
					(length 3.81)
					(name "gnd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "14"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 5.08 180)
					(length 3.81)
					(name "p23"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "16"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 2.54 180)
					(length 3.81)
					(name "p24"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "18"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 0 180)
					(length 3.81)
					(name "gnd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "20"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -2.54 180)
					(length 3.81)
					(name "p25"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "22"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -5.08 180)
					(length 3.81)
					(name "p08"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "24"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -7.62 180)
					(length 3.81)
					(name "p07"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "26"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -10.16 180)
					(length 3.81)
					(name "id_sc"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "28"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -12.7 180)
					(length 3.81)
					(name "gnd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "30"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -15.24 180)
					(length 3.81)
					(name "p12"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "32"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -17.78 180)
					(length 3.81)
					(name "gnd"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "34"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -20.32 180)
					(length 3.81)
					(name "p16"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "36"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -22.86 180)
					(length 3.81)
					(name "p20"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "38"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin passive line
					(at 7.62 -25.4 180)
					(length 3.81)
					(name "p21"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "40"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "power:GND"
			(power)
			(pin_numbers
				(hide yes)
			)
			(pin_names
				(offset 0)
				(hide yes)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "#PWR"
				(at 0 -6.35 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Value" "GND"
				(at 0 -3.81 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Footprint" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" "Power symbol creates a global label with name \"GND\" , ground"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "global power"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "GND_0_1"
				(polyline
					(pts
						(xy 0 0) (xy 0 -1.27) (xy 1.27 -1.27) (xy 0 -2.54) (xy -1.27 -1.27) (xy 0 -1.27)
					)
					(stroke
						(width 0)
						(type default)
					)
					(fill
						(type none)
					)
				)
			)
			(symbol "GND_1_1"
				(pin power_in line
					(at 0 0 270)
					(length 0)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "power:PWR_FLAG"
			(power)
			(pin_numbers
				(hide yes)
			)
			(pin_names
				(offset 0)
				(hide yes)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "#FLG"
				(at 0 1.905 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Value" "PWR_FLAG"
				(at 0 3.81 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Footprint" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" "~"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" "Special symbol for telling ERC where power comes from"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "flag power"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "PWR_FLAG_0_0"
				(pin power_out line
					(at 0 0 90)
					(length 0)
					(name "~"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(symbol "PWR_FLAG_0_1"
				(polyline
					(pts
						(xy 0 0) (xy 0 1.27) (xy -1.016 1.905) (xy 0 2.54) (xy 1.016 1.905) (xy 0 1.27)
					)
					(stroke
						(width 0)
						(type default)
					)
					(fill
						(type none)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "zynthiandac-rescue:ASCO-Oscillator"
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "X"
				(at -7.62 6.35 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(justify left)
				)
			)
			(property "Value" "ASCO-Oscillator"
				(at 1.27 -6.35 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(justify left)
				)
			)
			(property "Footprint" "Oscillator:Oscillator_SMD_Abracon_ASCO-4Pin_1.6x1.2mm"
				(at 2.54 -8.89 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" ""
				(at -5.715 3.175 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "Oscillator*Abracon*ASCO*1.6x1.2mm*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "ASCO-Oscillator_0_1"
				(rectangle
					(start -7.62 5.08)
					(end 7.62 -5.08)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type background)
					)
				)
				(polyline
					(pts
						(xy -5.715 2.54) (xy -5.08 2.54) (xy -5.08 3.81) (xy -4.445 3.81) (xy -4.445 2.54) (xy -3.81 2.54)
						(xy -3.81 3.81) (xy -3.175 3.81) (xy -3.175 2.54)
					)
					(stroke
						(width 0)
						(type solid)
					)
					(fill
						(type none)
					)
				)
			)
			(symbol "ASCO-Oscillator_1_1"
				(pin tri_state line
					(at -10.16 0 0)
					(length 2.54)
					(name "Tri-State"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin power_in line
					(at 0 7.62 270)
					(length 2.54)
					(name "VDD"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "4"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -7.62 90)
					(length 2.54)
					(name "GND"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin output line
					(at 10.16 0 180)
					(length 2.54)
					(name "OUT"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "3"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "zynthiandac-rescue:PCM1863DBT-pcm1863"
			(pin_names
				(offset 0.254)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "U"
				(at 40.64 10.16 0)
				(effects
					(font
						(size 1.524 1.524)
					)
				)
			)
			(property "Value" "PCM1863DBT-pcm1863"
				(at 40.64 7.62 0)
				(effects
					(font
						(size 1.524 1.524)
					)
				)
			)
			(property "Footprint" "DBT30_TEX"
				(at 40.64 6.096 0)
				(effects
					(font
						(size 1.524 1.524)
					)
					(hide yes)
				)
			)
			(property "Datasheet" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.524 1.524)
					)
				)
			)
			(property "Description" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_locked" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "ki_fp_filters" "DBT30_TEX DBT30_TEX-M DBT30_TEX-L"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "PCM1863DBT-pcm1863_1_1"
				(polyline
					(pts
						(xy 7.62 5.08) (xy 7.62 -40.64)
					)
					(stroke
						(width 0.127)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 7.62 -40.64) (xy 73.66 -40.64)
					)
					(stroke
						(width 0.127)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 73.66 5.08) (xy 7.62 5.08)
					)
					(stroke
						(width 0.127)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 73.66 -40.64) (xy 73.66 5.08)
					)
					(stroke
						(width 0.127)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(pin input line
					(at 0 0 0)
					(length 7.62)
					(name "VINL2/VIN1M"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 0 -2.54 0)
					(length 7.62)
					(name "VINR2/VIN2M"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 0 -5.08 0)
					(length 7.62)
					(name "VINL1/VIN1P"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "3"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 0 -7.62 0)
					(length 7.62)
					(name "VINR1/VIN2P"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "4"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin unspecified line
					(at 0 -10.16 0)
					(length 7.62)
					(name "MICBIAS"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "5"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -12.7 0)
					(length 7.62)
					(name "VREF"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "6"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -15.24 0)
					(length 7.62)
					(name "AGND"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "7"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -17.78 0)
					(length 7.62)
					(name "AVDD"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "8"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -20.32 0)
					(length 7.62)
					(name "XO"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "9"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 0 -22.86 0)
					(length 7.62)
					(name "XI"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "10"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -25.4 0)
					(length 7.62)
					(name "LDO"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "11"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -27.94 0)
					(length 7.62)
					(name "DGND"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "12"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -30.48 0)
					(length 7.62)
					(name "DVDD"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "13"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -33.02 0)
					(length 7.62)
					(name "IOVDD"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "14"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 0 -35.56 0)
					(length 7.62)
					(name "SCKI"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "15"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 81.28 0 180)
					(length 7.62)
					(name "VINR3/VIN3P"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "30"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 81.28 -2.54 180)
					(length 7.62)
					(name "VINL3/VIN4P"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "29"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 81.28 -5.08 180)
					(length 7.62)
					(name "VINR4/VIN3M"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "28"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 81.28 -7.62 180)
					(length 7.62)
					(name "VINL4/VIN4M"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "27"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 81.28 -10.16 180)
					(length 7.62)
					(name "MD0"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "26"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 81.28 -12.7 180)
					(length 7.62)
					(name "MS/AD"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "25"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 81.28 -15.24 180)
					(length 7.62)
					(name "MC/SCL"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "24"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 81.28 -17.78 180)
					(length 7.62)
					(name "MOSI/SDA"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "23"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 81.28 -20.32 180)
					(length 7.62)
					(name "MISO/GPIO0/DMIN2"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "22"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 81.28 -22.86 180)
					(length 7.62)
					(name "GPIO1/INTA/DMIN"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "21"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 81.28 -25.4 180)
					(length 7.62)
					(name "GPIO2/INTB/DMCLK"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "20"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 81.28 -27.94 180)
					(length 7.62)
					(name "GPIO3/INTC"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "19"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 81.28 -30.48 180)
					(length 7.62)
					(name "DOUT"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "18"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 81.28 -33.02 180)
					(length 7.62)
					(name "BCK"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "17"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 81.28 -35.56 180)
					(length 7.62)
					(name "LRCK"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "16"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "zynthiandac-rescue:PCM5242RHBR-pcm5242"
			(pin_names
				(offset 0.254)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "U"
				(at 22.86 10.16 0)
				(effects
					(font
						(size 1.524 1.524)
					)
				)
			)
			(property "Value" "PCM5242RHBR-pcm5242"
				(at 22.86 7.62 0)
				(effects
					(font
						(size 1.524 1.524)
					)
				)
			)
			(property "Footprint" "RHB32_3P45X3P45_TEX"
				(at 22.86 6.096 0)
				(effects
					(font
						(size 1.524 1.524)
					)
					(hide yes)
				)
			)
			(property "Datasheet" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.524 1.524)
					)
				)
			)
			(property "Description" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_locked" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "ki_fp_filters" "RHB32_3P45X3P45_TEX"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "PCM5242RHBR-pcm5242_1_1"
				(polyline
					(pts
						(xy 7.62 5.08) (xy 7.62 -45.72)
					)
					(stroke
						(width 0.127)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 7.62 -45.72) (xy 38.1 -45.72)
					)
					(stroke
						(width 0.127)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 38.1 5.08) (xy 7.62 5.08)
					)
					(stroke
						(width 0.127)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(polyline
					(pts
						(xy 38.1 -45.72) (xy 38.1 5.08)
					)
					(stroke
						(width 0.127)
						(type solid)
					)
					(fill
						(type none)
					)
				)
				(pin input line
					(at 0 0 0)
					(length 7.62)
					(name "XSMT"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -2.54 0)
					(length 7.62)
					(name "LDOO"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -5.08 0)
					(length 7.62)
					(name "DGND"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "3"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -7.62 0)
					(length 7.62)
					(name "DVDD"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "4"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -10.16 0)
					(length 7.62)
					(name "CPVDD"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "5"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -12.7 0)
					(length 7.62)
					(name "CAPP"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "6"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -15.24 0)
					(length 7.62)
					(name "CPGND"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "7"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -17.78 0)
					(length 7.62)
					(name "CAPM"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "8"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -20.32 0)
					(length 7.62)
					(name "VNEG"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "9"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -22.86 0)
					(length 7.62)
					(name "OUTLP"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "10"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -25.4 0)
					(length 7.62)
					(name "OUTLN"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "11"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -27.94 0)
					(length 7.62)
					(name "OUTRN"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "12"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin output line
					(at 0 -30.48 0)
					(length 7.62)
					(name "OUTRP"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "13"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -33.02 0)
					(length 7.62)
					(name "AVDD"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "14"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -35.56 0)
					(length 7.62)
					(name "AGND"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "15"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 0 -38.1 0)
					(length 7.62)
					(name "VCOM"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "16"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin unspecified line
					(at 45.72 0 180)
					(length 7.62)
					(name "EPAD"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "33"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -2.54 180)
					(length 7.62)
					(name "ADR1"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "32"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -5.08 180)
					(length 7.62)
					(name "LRCK"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "31"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin no_connect line
					(at 45.72 -7.62 180)
					(length 7.62)
					(name "NC"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "30"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin no_connect line
					(at 45.72 -10.16 180)
					(length 7.62)
					(name "NC"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "29"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 45.72 -12.7 180)
					(length 7.62)
					(name "DIN"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "28"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -15.24 180)
					(length 7.62)
					(name "BCK"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "27"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 45.72 -17.78 180)
					(length 7.62)
					(name "SCK"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "26"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -20.32 180)
					(length 7.62)
					(name "GPIO6"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "25"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 45.72 -22.86 180)
					(length 7.62)
					(name "MODE2"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "24"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 45.72 -25.4 180)
					(length 7.62)
					(name "MODE1"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "23"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -27.94 180)
					(length 7.62)
					(name "ADR2"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "22"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -30.48 180)
					(length 7.62)
					(name "GPIO3"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "21"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -33.02 180)
					(length 7.62)
					(name "GPIO4"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "20"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -35.56 180)
					(length 7.62)
					(name "GPIO5"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "19"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin input line
					(at 45.72 -38.1 180)
					(length 7.62)
					(name "SCL"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "18"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
				(pin bidirectional line
					(at 45.72 -40.64 180)
					(length 7.62)
					(name "SDA"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
					(number "17"
						(effects
							(font
								(size 1.4986 1.4986)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
		(symbol "zynthiandac-rescue:TLV71333PDBV-Regulator_Linear"
			(pin_names
				(offset 0.254)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "U"
				(at -3.81 5.715 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Value" "TLV71333PDBV-Regulator_Linear"
				(at 0 5.715 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(justify left)
				)
			)
			(property "Footprint" "Package_TO_SOT_SMD:SOT-23-5"
				(at 0 8.255 0)
				(effects
					(font
						(size 1.27 1.27)
						(italic yes)
					)
					(hide yes)
				)
			)
			(property "Datasheet" ""
				(at 0 1.27 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" ""
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "SOT?23*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "TLV71333PDBV-Regulator_Linear_0_1"
				(rectangle
					(start -5.08 4.445)
					(end 5.08 -5.08)
					(stroke
						(width 0.254)
						(type solid)
					)
					(fill
						(type background)
					)
				)
			)
			(symbol "TLV71333PDBV-Regulator_Linear_1_1"
				(pin power_in line
					(at -7.62 2.54 0)
					(length 2.54)
					(name "IN"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin input line
					(at -7.62 0 0)
					(length 2.54)
					(name "EN"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "3"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin power_in line
					(at 0 -7.62 90)
					(length 2.54)
					(name "GND"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin no_connect line
					(at 5.08 0 180)
					(length 2.54)
					(hide yes)
					(name "NC"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "4"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
				(pin power_out line
					(at 7.62 2.54 180)
					(length 2.54)
					(name "OUT"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
					(number "5"
						(effects
							(font
								(size 1.27 1.27)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)
	)
	(junction
		(at 121.92 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "0717670e-0931-4b84-a25e-509c22b40be4")
	)
	(junction
		(at 116.84 186.69)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "09dabb83-8280-4308-8cf7-6e5ab56f5b0e")
	)
	(junction
		(at 168.91 109.22)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "0caad6c1-d015-414a-b56c-e3d79dc624ae")
	)
	(junction
		(at 226.06 140.97)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "0f44308a-5c7c-4b6a-8fea-0fa445d009b5")
	)
	(junction
		(at 177.8 115.57)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "101b09dd-9742-4898-a1b2-dcddcc6bf36b")
	)
	(junction
		(at 237.49 173.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "1076f9db-e4aa-48d4-8ca9-26e7b252141d")
	)
	(junction
		(at 177.8 109.22)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "11b4d4fd-1ee1-4fc1-a1bd-3c8afb98fcc6")
	)
	(junction
		(at 226.06 138.43)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "1afcdc5a-da33-40a2-acd7-3c9fb93219d7")
	)
	(junction
		(at 139.7 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "1bda42b3-e7c0-4bed-aafa-bd38ce44b09f")
	)
	(junction
		(at 100.33 194.31)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "1fee11bd-85c6-4add-8021-fa06c9382fc6")
	)
	(junction
		(at 208.28 195.58)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "2078e453-1b37-4945-8254-69993b26023a")
	)
	(junction
		(at 157.48 33.02)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "21affe54-541b-46e4-be73-f552da579f11")
	)
	(junction
		(at 165.1 46.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "233b3129-b30f-4a90-b80a-2e501b51451d")
	)
	(junction
		(at 162.56 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "273fb27e-9594-47cb-822b-e47f9f1d6416")
	)
	(junction
		(at 129.54 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "27f91cef-16f7-476d-abf5-6a4679394e13")
	)
	(junction
		(at 157.48 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "28ac9f06-3d81-4f60-b331-7c8d186b60b6")
	)
	(junction
		(at 86.36 49.53)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "28e91bf8-f650-4efb-be81-a751a8737dc0")
	)
	(junction
		(at 205.74 187.96)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "2a380e22-f826-4207-9a6f-dd508a419fbd")
	)
	(junction
		(at 152.4 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "30872421-e11a-4036-9627-ba7fed051ff5")
	)
	(junction
		(at 156.21 74.93)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "3338c1bc-819e-4bed-a3db-94c748800cba")
	)
	(junction
		(at 199.39 101.6)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "346c319b-456c-450e-8068-a49f585cbc78")
	)
	(junction
		(at 124.46 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "34732195-d329-4e92-a698-21f481a26920")
	)
	(junction
		(at 180.34 100.33)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "34840f4f-8056-414d-83fc-b70b9a21f474")
	)
	(junction
		(at 85.09 185.42)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "3485d93e-231b-43df-b98a-447c90b78b3d")
	)
	(junction
		(at 128.27 59.69)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "35b73d68-444e-488d-acc6-6dcf3cd1c15f")
	)
	(junction
		(at 238.76 140.97)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "361ccbf9-a6fb-40cc-8b1d-e1f15c004b5a")
	)
	(junction
		(at 78.74 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "3740fd1e-5fb6-47d5-a316-29c2a91d556b")
	)
	(junction
		(at 295.91 135.89)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "37e5887a-4bee-4dcc-8659-3551e59fa96b")
	)
	(junction
		(at 168.91 101.6)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "37ed60c0-11e6-4d8c-aedb-c492360ff21a")
	)
	(junction
		(at 173.99 67.31)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "394dc169-d02e-4301-bfd1-46fdc40ab1c4")
	)
	(junction
		(at 119.38 74.93)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "3a977b8b-e2d9-4ea1-b463-7afc2cf1bbf2")
	)
	(junction
		(at 311.15 158.75)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "3eaef6b0-e83d-4797-996e-5f374a833b88")
	)
	(junction
		(at 119.38 46.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "3f478c34-e3a8-4b3d-a95a-9ac157a4b077")
	)
	(junction
		(at 323.85 133.35)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "417ddfeb-b9a6-464a-afb3-adffb7822a52")
	)
	(junction
		(at 233.68 148.59)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "45da6bf2-725a-4856-985a-4691b92f25be")
	)
	(junction
		(at 132.08 33.02)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "4688f85a-788a-4170-8da5-cdf4ad6880be")
	)
	(junction
		(at 30.48 151.13)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "473aeb02-c29e-4ae4-b47d-d05bfc06d71e")
	)
	(junction
		(at 66.04 124.46)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "4af763bb-2769-4def-9231-e4af4a9cfd76")
	)
	(junction
		(at 350.52 158.75)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "4d3db4f1-d704-4905-b01c-6894f3dadbc4")
	)
	(junction
		(at 299.72 130.81)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "4d49ab8a-abdd-42fd-9783-1cfbed808071")
	)
	(junction
		(at 106.68 59.69)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "4f99d6ec-245a-43ce-b199-e8b6c7b5b5e8")
	)
	(junction
		(at 74.93 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "5214d86a-3d90-4518-8fac-fb7df2f3d55c")
	)
	(junction
		(at 285.75 110.49)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "53cc715c-66e4-46db-be7b-5e91558af8dd")
	)
	(junction
		(at 62.23 116.84)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "5750a0d0-d270-47c6-9c17-63fceb000388")
	)
	(junction
		(at 163.83 104.14)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "5829988b-655d-43fe-8112-1539162356a5")
	)
	(junction
		(at 147.32 48.26)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "589fbbc2-7918-40cf-93f2-30b796b2f74f")
	)
	(junction
		(at 355.6 121.92)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "5c483811-8262-4988-b6b0-db0d557a0386")
	)
	(junction
		(at 132.08 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "5ff5bc92-2eca-4527-9deb-9cef6755646b")
	)
	(junction
		(at 119.38 67.31)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "619d09c1-0652-4ea7-a875-2e38b4e5c1ea")
	)
	(junction
		(at 78.74 33.02)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "631d5b11-ad3e-43a7-970c-688d41f1ce11")
	)
	(junction
		(at 205.74 195.58)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "67d6c5b4-de0e-4352-8692-e616aafa39ed")
	)
	(junction
		(at 86.36 39.37)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "68f0bb42-d1b1-489a-98e9-6c70e6aec31a")
	)
	(junction
		(at 144.78 74.93)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "6abea754-7061-4c88-a997-7abc44f1497d")
	)
	(junction
		(at 27.94 135.89)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "6b5cfca3-3f7c-4076-9699-179120f83908")
	)
	(junction
		(at 135.89 74.93)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "6bbbb5cd-9772-4a01-afee-ce6493b105b3")
	)
	(junction
		(at 163.83 74.93)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "6beac544-104a-4731-88ee-6058866e5855")
	)
	(junction
		(at 119.38 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "6cc14959-1c11-44ae-a675-eb637ee70762")
	)
	(junction
		(at 238.76 121.92)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "711d6827-4a58-40b6-b701-4d9594885b7c")
	)
	(junction
		(at 69.85 196.85)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "71d51840-f18d-4460-8d92-87a7a1c5a3c8")
	)
	(junction
		(at 168.91 116.84)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "74738af7-888b-46d0-8976-b9311015addb")
	)
	(junction
		(at 226.06 130.81)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "7535cc8b-2bc9-44b7-8d70-503ea2c31848")
	)
	(junction
		(at 232.41 138.43)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "78df682d-89be-4768-ab83-af2188b8ed9c")
	)
	(junction
		(at 116.84 196.85)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "7d67b427-4521-4369-b810-a6239ae5d276")
	)
	(junction
		(at 180.34 109.22)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "7e539850-9205-41c3-bbdc-3656264185cd")
	)
	(junction
		(at 96.52 193.04)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "7f8f6904-079d-4048-bac7-94df46cf688f")
	)
	(junction
		(at 346.71 158.75)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "80758af2-24b6-4f68-9740-bbf1b7d98eec")
	)
	(junction
		(at 76.2 49.53)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "80d91609-ec84-4b9f-84e8-9aa35060e886")
	)
	(junction
		(at 66.04 86.36)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "82023200-fb3f-43c3-8ff7-ba6b26ffd760")
	)
	(junction
		(at 226.06 148.59)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "854e0802-9cc1-49d8-b9ec-9539b15fb74a")
	)
	(junction
		(at 149.86 46.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "85e7a346-d674-4cac-b9f2-9adde2bc0448")
	)
	(junction
		(at 152.4 33.02)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "863360b3-9fc8-4e00-bda0-ed97a83e6cbe")
	)
	(junction
		(at 186.69 100.33)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "8651f882-6077-4413-b526-cabc8f03d88f")
	)
	(junction
		(at 127 46.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "878e5091-2d02-49ee-a09d-6201e3577fbe")
	)
	(junction
		(at 102.87 67.31)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "88d7bbbe-5170-473d-bcc2-070b8ecfbaad")
	)
	(junction
		(at 186.69 109.22)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "8a076260-6ee5-48af-9231-640c2ce7ab15")
	)
	(junction
		(at 175.26 109.22)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "9482b5a6-fbe8-4035-9698-d84b3f9cbf83")
	)
	(junction
		(at 218.44 185.42)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "94ba4459-2927-4c23-b4b7-8f2ee72f2d20")
	)
	(junction
		(at 294.64 158.75)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "98791486-7114-40b0-a1b6-ccd271e6bfcd")
	)
	(junction
		(at 102.87 74.93)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "a335eb40-1315-4c3c-8629-7b79872fe1d2")
	)
	(junction
		(at 87.63 41.91)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "a6c610d6-40a7-4efb-9ed7-502459c41587")
	)
	(junction
		(at 350.52 143.51)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "a8e9f05d-e922-46c5-8589-2b82107585a6")
	)
	(junction
		(at 139.7 33.02)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "ac64a8c0-f623-465c-96f7-284eb7822772")
	)
	(junction
		(at 30.48 163.83)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "b0b3dbf3-b8de-4881-abff-45174dfef96e")
	)
	(junction
		(at 127 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "b10ebf96-7040-4938-b21b-72bc23535028")
	)
	(junction
		(at 212.09 195.58)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "b41cf96c-147e-4c33-9a38-fc607e72a416")
	)
	(junction
		(at 285.75 121.92)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "b611bb03-813f-4e6d-b170-887ebc47b3df")
	)
	(junction
		(at 222.25 148.59)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "b98dfc0f-2545-4e52-b665-8c216d2278d4")
	)
	(junction
		(at 102.87 64.77)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "bdf90d9b-a647-4e21-afd1-130b8cbb7291")
	)
	(junction
		(at 85.09 193.04)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "bf0c7cfa-bd9c-4581-bf0c-445df16d2904")
	)
	(junction
		(at 128.27 67.31)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "bf89ab74-07e7-492e-92e5-6602c7527c8e")
	)
	(junction
		(at 307.34 88.9)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c19799f4-2143-4e62-9364-2254c025f4a8")
	)
	(junction
		(at 149.86 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c25474dc-80a1-475c-88af-d8dbbf537ec7")
	)
	(junction
		(at 201.93 101.6)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c2ba8ead-08b3-4322-9903-e067ed8985e4")
	)
	(junction
		(at 321.31 130.81)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c441dc92-0934-43a5-9fd5-ba07d52a5a2d")
	)
	(junction
		(at 48.26 151.13)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c4b583af-2091-4bf1-9806-67c3489e79ba")
	)
	(junction
		(at 147.32 46.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c59bf13b-86eb-4e41-99ac-cf7368985649")
	)
	(junction
		(at 144.78 67.31)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c7e55285-3e15-4c30-8a1c-a55ddbd665da")
	)
	(junction
		(at 170.18 127)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c7ff71e6-a867-4de3-9bae-b89865b1f5bc")
	)
	(junction
		(at 374.65 121.92)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c86b68f5-553f-436e-9916-370e4c99e142")
	)
	(junction
		(at 74.93 49.53)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "c88267d0-81b0-4e53-8658-0c2daceac9b9")
	)
	(junction
		(at 355.6 137.16)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "cbe95134-4409-43c8-804e-5e1263a867e2")
	)
	(junction
		(at 241.3 140.97)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "cda77896-559f-4158-87e2-521720661929")
	)
	(junction
		(at 160.02 46.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "cf7f1962-8a27-4921-ab13-ae6dd8379c0b")
	)
	(junction
		(at 156.21 67.31)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "cf8aa295-1915-4946-82d9-76f3779eb7c8")
	)
	(junction
		(at 99.06 185.42)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "d133221d-3b93-4c06-b310-c1b78370df9c")
	)
	(junction
		(at 102.87 59.69)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "d33b6fa4-6099-4bae-a71d-51457d0a912c")
	)
	(junction
		(at 237.49 166.37)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "d4bb3a59-9813-4e61-8820-e2e12e0f2330")
	)
	(junction
		(at 69.85 186.69)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "dc8e003f-b5c8-4abb-a935-b21cdfb60f84")
	)
	(junction
		(at 166.37 109.22)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "df39de88-424d-475e-9889-ae261ba36d26")
	)
	(junction
		(at 318.77 135.89)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "dfaab412-9f0d-4995-8fc6-a10e38ab995f")
	)
	(junction
		(at 199.39 185.42)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "e03ddc15-5353-429d-9d3c-3f2ca29483ee")
	)
	(junction
		(at 193.04 109.22)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "e0879b37-74fe-431d-97ac-4798768131b3")
	)
	(junction
		(at 116.84 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "e34801b7-de7c-47fc-86d8-2861c9639847")
	)
	(junction
		(at 128.27 74.93)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "e3c27a7b-368e-4450-8cd4-aa868ab3b2ea")
	)
	(junction
		(at 121.92 46.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "e3e152e6-3542-442d-995a-e1a1a2fcf3cc")
	)
	(junction
		(at 110.49 74.93)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "ee5a71ff-1aaf-44a1-b593-db7efc1b7545")
	)
	(junction
		(at 232.41 166.37)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "eeaf3900-09e2-4b99-876b-24f1a8e28474")
	)
	(junction
		(at 165.1 34.29)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "eec2ed17-0a97-4f9d-ab07-7bed4c3797a5")
	)
	(junction
		(at 156.21 64.77)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "f06b6919-99d7-48f7-93a5-2afe7986833a")
	)
	(junction
		(at 128.27 64.77)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "f2cbda82-aef4-4fef-9fd5-5433af92a0fa")
	)
	(junction
		(at 323.85 143.51)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "f7476285-8d84-4695-a399-09990dd2054a")
	)
	(junction
		(at 234.95 173.99)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "f7e5a342-a803-41ed-9920-baf4411ab145")
	)
	(junction
		(at 212.09 187.96)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "f7fd1ebe-1287-4a6d-9988-06ceff2d6207")
	)
	(junction
		(at 66.04 116.84)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "f9aa5628-6344-49d5-b0fc-8b6701e8965b")
	)
	(junction
		(at 170.18 109.22)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "f9b45779-e7ef-4528-87f0-b542df8fbe09")
	)
	(junction
		(at 240.03 171.45)
		(diameter 0)
		(color 0 0 0 0)
		(uuid "fa1b1994-1d30-4654-9cc1-cc0ea5adf4b7")
	)
	(no_connect
		(at 90.17 208.28)
		(uuid "3acc6fd9-acaa-4c92-ae1e-48cb9aa6f5ff")
	)
	(no_connect
		(at 76.2 137.16)
		(uuid "3c591f0c-ce1b-4deb-924b-8753ed2219d7")
	)
	(no_connect
		(at 76.2 109.22)
		(uuid "626d5a9e-5d9e-4993-8cbc-a2832ee1bb93")
	)
	(no_connect
		(at 76.2 132.08)
		(uuid "856dea9d-a523-4e96-98f2-b702614b39b6")
	)
	(no_connect
		(at 76.2 134.62)
		(uuid "861ccae6-bd1b-4443-956d-17e885447dca")
	)
	(no_connect
		(at 76.2 129.54)
		(uuid "a6ba30f9-0b56-40d0-8595-fc71192f5c03")
	)
	(no_connect
		(at 33.02 153.67)
		(uuid "b3f5c9a5-b65a-40c3-8b2d-658a40593d56")
	)
	(no_connect
		(at 76.2 114.3)
		(uuid "be33de02-158a-4485-826f-89a95b06fef0")
	)
	(no_connect
		(at 157.48 116.84)
		(uuid "c321a60a-52e1-4d98-8c1c-128ef68051bc")
	)
	(no_connect
		(at 90.17 210.82)
		(uuid "df4c2a98-f6a2-4fa2-945d-2ec321c99ec6")
	)
	(no_connect
		(at 289.56 168.91)
		(uuid "ea804d63-71b1-4797-9375-134ec4de4974")
	)
	(no_connect
		(at 157.48 114.3)
		(uuid "f0331dda-98be-4004-8334-9306713d24fb")
	)
	(wire
		(pts
			(xy 66.04 127) (xy 66.04 124.46)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "00ced9ed-753d-4b3d-b5c5-12892413a3d6")
	)
	(wire
		(pts
			(xy 96.52 49.53) (xy 96.52 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "010f4479-b66b-4dfa-a0c1-c0d11f4fb27d")
	)
	(wire
		(pts
			(xy 345.44 133.35) (xy 345.44 129.54)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "024e3ac7-77eb-4d12-b2ea-d8e5d698f7e4")
	)
	(wire
		(pts
			(xy 163.83 134.62) (xy 157.48 134.62)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0251105f-e174-4655-b720-eb81f0aee8cc")
	)
	(wire
		(pts
			(xy 199.39 185.42) (xy 199.39 187.96)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "03c92cf6-bb90-485c-874c-f349006d4461")
	)
	(wire
		(pts
			(xy 243.84 156.21) (xy 209.55 156.21)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "049646e7-5df8-4881-890e-0ca414cc8f7a")
	)
	(wire
		(pts
			(xy 191.77 227.33) (xy 191.77 224.79)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0533ee55-091e-42bf-8131-55f46f0c3604")
	)
	(wire
		(pts
			(xy 311.15 166.37) (xy 309.88 166.37)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "053de6b2-c7dd-4d56-8d60-0aef274d9e19")
	)
	(wire
		(pts
			(xy 76.2 116.84) (xy 66.04 116.84)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0615ca97-3dbb-4572-a3f2-5684654f870e")
	)
	(wire
		(pts
			(xy 96.52 194.31) (xy 96.52 193.04)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "06904d63-8ab0-4127-a5e8-161bf4fc7ffe")
	)
	(wire
		(pts
			(xy 78.74 49.53) (xy 76.2 49.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "06b0c08b-4c82-4cef-a44f-5d1152f9e3e5")
	)
	(wire
		(pts
			(xy 96.52 33.02) (xy 78.74 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "06e86bd7-6622-4a5b-942e-640f5d850cd5")
	)
	(wire
		(pts
			(xy 186.69 109.22) (xy 193.04 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "06f8db3b-b768-414a-b831-b1a11bb90f56")
	)
	(wire
		(pts
			(xy 121.92 176.53) (xy 121.92 177.8)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "083a0a76-1e34-4023-a9ea-4b72c21c394d")
	)
	(wire
		(pts
			(xy 199.39 175.26) (xy 199.39 176.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "089cb8ec-809c-4dbd-bd20-d261b98183dd")
	)
	(wire
		(pts
			(xy 157.48 121.92) (xy 166.37 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "08a67f85-3ab8-44dd-af2e-6dd91e92ab3c")
	)
	(wire
		(pts
			(xy 46.99 17.78) (xy 46.99 86.36)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "08e29841-a84f-4f9d-be08-73957ce8a18b")
	)
	(wire
		(pts
			(xy 45.72 116.84) (xy 46.99 116.84)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0a41cd00-27d0-4d7f-a4ec-aa42181ee717")
	)
	(wire
		(pts
			(xy 321.31 125.73) (xy 323.85 125.73)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0b477073-4bb3-4ab5-ab2a-afd17cda0fa6")
	)
	(wire
		(pts
			(xy 323.85 133.35) (xy 345.44 133.35)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0b82a9cc-2eb2-4721-a0ec-291ad5dc7c1f")
	)
	(wire
		(pts
			(xy 346.71 158.75) (xy 346.71 161.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0bb5b98f-0f3a-48af-bdc8-95dca26c35d6")
	)
	(wire
		(pts
			(xy 104.14 194.31) (xy 100.33 194.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0bbbb5d4-db21-4bc9-9721-399f89195874")
	)
	(wire
		(pts
			(xy 168.91 124.46) (xy 157.48 124.46)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0c1f8b4c-842d-4cfe-a295-79265dbb969e")
	)
	(wire
		(pts
			(xy 76.2 194.31) (xy 85.09 194.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0c723213-d85a-4e93-a3a9-02f2ee153ed4")
	)
	(wire
		(pts
			(xy 102.87 64.77) (xy 102.87 59.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0cb2cce4-fdbf-4601-88ab-75d32acdc867")
	)
	(wire
		(pts
			(xy 119.38 46.99) (xy 119.38 53.34)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0d1c6d64-6297-4fd5-8b47-69f5891ef488")
	)
	(wire
		(pts
			(xy 86.36 44.45) (xy 86.36 49.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0d523569-6fb6-4fad-8273-aad73566a87b")
	)
	(wire
		(pts
			(xy 311.15 105.41) (xy 311.15 86.36)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0db48591-ceb6-43a8-8d7c-8e3f5512f5e3")
	)
	(wire
		(pts
			(xy 241.3 143.51) (xy 241.3 140.97)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0fc62d6a-1cf9-451e-b9f1-3b5e7c287f4d")
	)
	(wire
		(pts
			(xy 149.86 29.21) (xy 149.86 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "0feeef5f-c8f5-4d66-bcb5-2529adbb83fd")
	)
	(wire
		(pts
			(xy 193.04 109.22) (xy 199.39 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1240a70f-349f-4e65-bf0d-1e069a3240a8")
	)
	(wire
		(pts
			(xy 46.99 86.36) (xy 66.04 86.36)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1291a4d4-dc47-485e-8b08-539f7aa281ef")
	)
	(wire
		(pts
			(xy 165.1 161.29) (xy 72.39 161.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "12cc89b1-fcad-4dbf-a900-0a63925aa4ac")
	)
	(wire
		(pts
			(xy 27.94 128.27) (xy 27.94 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "133fd7ac-eaa6-4c86-906a-b04f8531ed8c")
	)
	(wire
		(pts
			(xy 76.2 186.69) (xy 69.85 186.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "13f1dae0-740f-4ec0-a6ea-ca5919e8e137")
	)
	(wire
		(pts
			(xy 303.53 135.89) (xy 318.77 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1479117e-a795-439b-80c4-b83c2a2e8bf9")
	)
	(wire
		(pts
			(xy 165.1 46.99) (xy 165.1 48.26)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "14ef1c2d-28c0-4fb7-b94e-179d9ab040b9")
	)
	(wire
		(pts
			(xy 118.11 67.31) (xy 119.38 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "157a83a4-c1f9-4648-a298-e393107d6f97")
	)
	(wire
		(pts
			(xy 25.4 148.59) (xy 33.02 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1633fb9c-2015-47c7-864c-5f5f56263611")
	)
	(wire
		(pts
			(xy 180.34 101.6) (xy 180.34 100.33)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "16cd0c74-fa5f-4bb0-9583-1d6a29127254")
	)
	(wire
		(pts
			(xy 374.65 121.92) (xy 374.65 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "185c7114-6c72-45ee-a4c7-e431e5fed500")
	)
	(wire
		(pts
			(xy 86.36 26.67) (xy 87.63 26.67)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "19015b4e-b931-40e2-8b27-373d0c791a4d")
	)
	(wire
		(pts
			(xy 177.8 109.22) (xy 175.26 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "197f1f1c-f3e7-4ce8-be3d-3b4a17c2a081")
	)
	(wire
		(pts
			(xy 162.56 137.16) (xy 157.48 137.16)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "19940277-18d4-43da-b03a-23ab47b00e0e")
	)
	(wire
		(pts
			(xy 168.91 101.6) (xy 175.26 101.6)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "19f9d3b8-9606-4699-b378-d544beda9899")
	)
	(wire
		(pts
			(xy 127 29.21) (xy 127 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1a458470-74c0-4af5-84b9-448bd63572b1")
	)
	(wire
		(pts
			(xy 177.8 121.92) (xy 177.8 115.57)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1aef6e9a-f404-4cb9-afa0-aa89167a834a")
	)
	(wire
		(pts
			(xy 121.92 34.29) (xy 121.92 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1b074c57-ce4b-4194-8ec6-955033aa8663")
	)
	(wire
		(pts
			(xy 212.09 176.53) (xy 212.09 161.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1c6f591a-4c7f-4950-87cd-615f6a5f4965")
	)
	(wire
		(pts
			(xy 45.72 138.43) (xy 53.34 138.43)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1e421002-4fc3-4061-9b5d-0469b7230bf2")
	)
	(wire
		(pts
			(xy 209.55 156.21) (xy 209.55 175.26)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1e4e1ad2-4d0b-4c46-bf97-c3c448bfc599")
	)
	(wire
		(pts
			(xy 243.84 171.45) (xy 240.03 171.45)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1e97840d-5eb2-4c43-a4e0-b4b5ffb693c1")
	)
	(wire
		(pts
			(xy 289.56 153.67) (xy 302.26 153.67)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1ef9a6b9-4bdc-4074-b24f-fc3ab713b97a")
	)
	(wire
		(pts
			(xy 139.7 33.02) (xy 152.4 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1f4f6504-0802-4f18-b376-2ed17be747d3")
	)
	(wire
		(pts
			(xy 294.64 161.29) (xy 294.64 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "1f5d4659-7d27-40a5-936b-7938f73def99")
	)
	(wire
		(pts
			(xy 289.56 156.21) (xy 295.91 156.21)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "203486be-a321-43ff-a7f1-71d5fdf420fc")
	)
	(wire
		(pts
			(xy 303.53 135.89) (xy 303.53 163.83)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2092e360-7508-418d-ab51-397280fa0943")
	)
	(wire
		(pts
			(xy 289.56 161.29) (xy 294.64 161.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "21697403-1785-4999-aa56-ebb1833e32fb")
	)
	(wire
		(pts
			(xy 157.48 119.38) (xy 201.93 119.38)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "23fff5fb-9f82-44b2-8a54-7b56a667459d")
	)
	(wire
		(pts
			(xy 139.7 34.29) (xy 139.7 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "25fed5f8-dd8e-48ac-8aca-7ee4d1585363")
	)
	(wire
		(pts
			(xy 62.23 116.84) (xy 62.23 123.19)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "29a55828-04a1-4f92-a0a0-1059afcd6e77")
	)
	(wire
		(pts
			(xy 45.72 156.21) (xy 53.34 156.21)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2a8ac2e0-5350-46cb-a52b-afe25cef6ab9")
	)
	(wire
		(pts
			(xy 240.03 152.4) (xy 241.3 152.4)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2ba2a85b-6f3c-4f0c-8f3f-449fc6a5a541")
	)
	(wire
		(pts
			(xy 156.21 59.69) (xy 156.21 64.77)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2ba55eb9-0072-4b8f-a476-3a905aa75092")
	)
	(wire
		(pts
			(xy 119.38 74.93) (xy 128.27 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2bb91485-3af8-4e4f-89e9-1c80d1def1ae")
	)
	(wire
		(pts
			(xy 204.47 187.96) (xy 205.74 187.96)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2be1c0d4-6d3c-49a0-a872-062d54cda8f7")
	)
	(wire
		(pts
			(xy 45.72 111.76) (xy 45.72 116.84)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2e333319-4b13-48a3-abb3-91757138beb3")
	)
	(wire
		(pts
			(xy 285.75 113.03) (xy 285.75 110.49)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2fc0b4d2-2777-4dd4-9a3c-39ce523efc2f")
	)
	(wire
		(pts
			(xy 204.47 101.6) (xy 201.93 101.6)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2fde3329-67f3-49c6-8eff-c39b636bad49")
	)
	(wire
		(pts
			(xy 307.34 113.03) (xy 307.34 138.43)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "2ffb0883-f12b-454b-af6a-a1fe13e660ce")
	)
	(wire
		(pts
			(xy 233.68 148.59) (xy 243.84 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3037f7c5-92ca-4bc0-a541-9f0131e1d979")
	)
	(wire
		(pts
			(xy 243.84 110.49) (xy 285.75 110.49)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "304e2f36-2b5c-4dd8-b6f1-078dc3587195")
	)
	(wire
		(pts
			(xy 102.87 67.31) (xy 102.87 64.77)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "30d492fd-1ca5-402c-9715-4c7a89f5ce1a")
	)
	(wire
		(pts
			(xy 289.56 163.83) (xy 303.53 163.83)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3105e89f-849a-459a-be30-9ff1cce0aa25")
	)
	(wire
		(pts
			(xy 167.64 33.02) (xy 167.64 46.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "325b1432-507a-4b19-9a35-6e5bc135a728")
	)
	(wire
		(pts
			(xy 170.18 115.57) (xy 168.91 115.57)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "331b98e2-af7a-466d-847c-9ee6474a1629")
	)
	(wire
		(pts
			(xy 66.04 86.36) (xy 66.04 104.14)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "33406fae-1f24-4478-814b-7c48ec2b1432")
	)
	(wire
		(pts
			(xy 73.66 121.92) (xy 76.2 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3347d49a-1a36-434c-813b-cdfd03c4066b")
	)
	(wire
		(pts
			(xy 226.06 148.59) (xy 233.68 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "33a1bb12-5a3d-4b5f-b262-df7088607224")
	)
	(wire
		(pts
			(xy 152.4 33.02) (xy 157.48 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "340544d2-84a7-4d6d-ae49-16112690affd")
	)
	(wire
		(pts
			(xy 135.89 76.2) (xy 135.89 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "343ffc2d-7222-4da4-82aa-34edfe9e7c98")
	)
	(wire
		(pts
			(xy 212.09 195.58) (xy 218.44 195.58)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "358924fd-09f4-4a60-b307-aed8ac424169")
	)
	(wire
		(pts
			(xy 242.57 144.78) (xy 242.57 146.05)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "35b65930-2834-472d-bfed-df8eb485ae06")
	)
	(wire
		(pts
			(xy 143.51 64.77) (xy 143.51 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3707460f-2c3e-4643-ab13-277b18946e65")
	)
	(wire
		(pts
			(xy 157.48 109.22) (xy 166.37 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "380b63d1-b70e-4767-bba1-fba54b5cdc85")
	)
	(wire
		(pts
			(xy 237.49 173.99) (xy 234.95 173.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3839c895-1fcb-4a44-a9be-4e9bb5d52bbc")
	)
	(wire
		(pts
			(xy 54.61 111.76) (xy 76.2 111.76)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "386f4727-24e7-46aa-9d0b-530f30c524d0")
	)
	(wire
		(pts
			(xy 355.6 137.16) (xy 350.52 137.16)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "38c38a0b-d18f-4903-9ec7-aa717d88f615")
	)
	(wire
		(pts
			(xy 166.37 109.22) (xy 168.91 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3b1827ab-e548-4c2d-993b-90fec3a75f83")
	)
	(wire
		(pts
			(xy 212.09 184.15) (xy 212.09 187.96)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3b8da27a-e3a1-499b-9ab0-b1fd4f0a5b80")
	)
	(wire
		(pts
			(xy 379.73 124.46) (xy 379.73 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3bc1e418-f5e7-4021-bd5d-fec32cfd852c")
	)
	(wire
		(pts
			(xy 99.06 168.91) (xy 99.06 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3cc96c94-b744-46e2-bd60-a3a73ed5adcd")
	)
	(wire
		(pts
			(xy 53.34 153.67) (xy 45.72 153.67)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3d1cd2d8-e2f4-43eb-9e22-530635fd8647")
	)
	(wire
		(pts
			(xy 48.26 143.51) (xy 45.72 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3eda82e2-10b4-4d6c-b0fb-8554799b8cee")
	)
	(wire
		(pts
			(xy 214.63 148.59) (xy 222.25 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "3f98fad2-6097-4125-8672-e25b0f920537")
	)
	(wire
		(pts
			(xy 232.41 138.43) (xy 243.84 138.43)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "403dda84-de47-4ccc-b8ae-dab77760a674")
	)
	(wire
		(pts
			(xy 119.38 67.31) (xy 120.65 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "414d425d-6e6b-4592-a122-f93a4e170337")
	)
	(wire
		(pts
			(xy 85.09 193.04) (xy 96.52 193.04)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "416676a0-bec9-439c-b13f-100974259a46")
	)
	(wire
		(pts
			(xy 285.75 110.49) (xy 295.91 110.49)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4168059e-e0f4-4d00-84ef-9b8aaa6bcff7")
	)
	(wire
		(pts
			(xy 289.56 148.59) (xy 311.15 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "430f0bcf-c897-4955-9423-2ddd1dfeeac1")
	)
	(wire
		(pts
			(xy 157.48 127) (xy 170.18 127)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "439bdc45-77b8-4477-a59e-4bb7e9ee067c")
	)
	(wire
		(pts
			(xy 121.92 53.34) (xy 121.92 46.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "43b64a56-4a56-4d98-839b-2a3a4123b715")
	)
	(wire
		(pts
			(xy 199.39 184.15) (xy 199.39 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "43ff52de-c31a-48ac-aafe-b10bed2309eb")
	)
	(wire
		(pts
			(xy 170.18 127) (xy 171.45 127)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "44f42fad-7144-45ce-b707-12e06a3af4dd")
	)
	(wire
		(pts
			(xy 74.93 31.75) (xy 74.93 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "450674e7-9ea9-4d3a-a236-385c001417ff")
	)
	(wire
		(pts
			(xy 243.84 166.37) (xy 237.49 166.37)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4626b00f-cd9d-4efc-b11a-db372ebc64d4")
	)
	(wire
		(pts
			(xy 241.3 140.97) (xy 243.84 140.97)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "472752bb-1e5f-4aa5-81af-21b71537cc68")
	)
	(wire
		(pts
			(xy 171.45 64.77) (xy 171.45 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "47cf825c-1135-404f-8f38-a1d7618a6a32")
	)
	(wire
		(pts
			(xy 87.63 41.91) (xy 85.09 41.91)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "47f6a46b-415b-484a-8ecd-2ec96ba93634")
	)
	(wire
		(pts
			(xy 177.8 115.57) (xy 177.8 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "486797c0-e160-4d28-b505-c43fb209926e")
	)
	(wire
		(pts
			(xy 100.33 194.31) (xy 96.52 194.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "49b76627-e9d7-44d0-b085-1ef5dbd2a3a6")
	)
	(wire
		(pts
			(xy 289.56 132.08) (xy 292.1 132.08)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4a8a253c-5e8d-417d-8d1e-69d2b3950533")
	)
	(wire
		(pts
			(xy 162.56 16.51) (xy 162.56 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4ad2aaa5-8edb-4d88-ab1b-b4273cf796f4")
	)
	(wire
		(pts
			(xy 93.98 213.36) (xy 90.17 213.36)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4b030692-7ce5-46cc-916b-706b8c145950")
	)
	(wire
		(pts
			(xy 30.48 163.83) (xy 48.26 163.83)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4b0e210b-ed8f-4684-9ba4-41ac8c99825c")
	)
	(wire
		(pts
			(xy 243.84 135.89) (xy 242.57 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4b708465-3fa6-4406-a9b2-e87b1bd897e9")
	)
	(wire
		(pts
			(xy 323.85 130.81) (xy 321.31 130.81)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4c3ac867-67a6-4598-b063-15de1bc8e876")
	)
	(wire
		(pts
			(xy 238.76 121.92) (xy 238.76 140.97)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4d95e62b-806d-4fe6-90ca-3ec9f11f54fb")
	)
	(wire
		(pts
			(xy 168.91 116.84) (xy 168.91 124.46)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "4e64a0c2-158d-4f50-a1f6-5ca858650944")
	)
	(wire
		(pts
			(xy 218.44 163.83) (xy 218.44 176.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5158c7ac-d3b2-441c-ae8a-165858b2f1af")
	)
	(wire
		(pts
			(xy 73.66 31.75) (xy 74.93 31.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "51c5e4e4-d413-4791-8d72-295ab66d0a51")
	)
	(wire
		(pts
			(xy 332.74 151.13) (xy 354.33 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "51e4cddd-98a8-48d5-9ab2-c488a81b039e")
	)
	(wire
		(pts
			(xy 173.99 67.31) (xy 177.8 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "521d5f88-7052-4f66-acc9-7bbf6595ec42")
	)
	(wire
		(pts
			(xy 82.55 160.02) (xy 163.83 160.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "53ea45ed-4218-440f-b7bf-9df9914b439b")
	)
	(wire
		(pts
			(xy 365.76 125.73) (xy 365.76 129.54)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5417f7ee-b706-4c2f-9daf-11be6dd0d0b4")
	)
	(wire
		(pts
			(xy 147.32 46.99) (xy 147.32 48.26)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5457c53e-fdd4-4811-a95c-f174bc519093")
	)
	(wire
		(pts
			(xy 149.86 46.99) (xy 149.86 52.07)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "54c55867-e3c1-483e-90c3-292f538dcb21")
	)
	(wire
		(pts
			(xy 88.9 39.37) (xy 86.36 39.37)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5549bec4-0569-49b0-8164-db8724d98dce")
	)
	(wire
		(pts
			(xy 222.25 148.59) (xy 226.06 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "565eabfd-a6f3-46f7-af55-bed3f23a90cc")
	)
	(wire
		(pts
			(xy 128.27 74.93) (xy 135.89 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "58b78ea1-57d9-46d4-8deb-c42593b26ed7")
	)
	(wire
		(pts
			(xy 165.1 101.6) (xy 168.91 101.6)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "58bdd76d-3b43-4859-affc-1eea42f5458e")
	)
	(wire
		(pts
			(xy 82.55 168.91) (xy 82.55 160.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "58c5b60d-f5c2-477b-a296-992da2568693")
	)
	(wire
		(pts
			(xy 116.84 53.34) (xy 119.38 53.34)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "590b890e-57bf-4c41-9c4b-4389fe984845")
	)
	(wire
		(pts
			(xy 135.89 74.93) (xy 144.78 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "594eb1ad-0b82-4dda-9d83-ad1d74ffe410")
	)
	(wire
		(pts
			(xy 143.51 67.31) (xy 144.78 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "59def4d4-9ee4-4652-af63-6ac5b3f9b3ea")
	)
	(wire
		(pts
			(xy 69.85 196.85) (xy 92.71 196.85)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5a21a8a4-1d9c-4c1a-b8b0-ae52c0d37c15")
	)
	(wire
		(pts
			(xy 128.27 64.77) (xy 128.27 59.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5a98f44f-ee01-46b7-8d24-f957cd4396b2")
	)
	(wire
		(pts
			(xy 45.72 16.51) (xy 162.56 16.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5b0e7cb4-cab4-497f-b0b6-08c04b133429")
	)
	(wire
		(pts
			(xy 87.63 26.67) (xy 87.63 41.91)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5db50824-b07a-4f26-94c2-fa91fa05b7cf")
	)
	(wire
		(pts
			(xy 234.95 173.99) (xy 232.41 173.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "5fc8da88-3585-4fce-8639-85a4cf697f4d")
	)
	(wire
		(pts
			(xy 25.4 158.75) (xy 33.02 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "6057cbc6-4741-4107-8cdf-5da6d693a578")
	)
	(wire
		(pts
			(xy 99.06 34.29) (xy 99.06 59.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "60a2325b-fefb-4876-907a-27d3e5e27a47")
	)
	(wire
		(pts
			(xy 157.48 111.76) (xy 165.1 111.76)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "60b8d580-eda5-4f55-8cbf-63e8d1b05548")
	)
	(wire
		(pts
			(xy 93.98 204.47) (xy 93.98 213.36)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "61ac482f-0226-485c-b5dd-c0e7a9dff489")
	)
	(wire
		(pts
			(xy 332.74 135.89) (xy 332.74 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "627f4982-ccc3-484c-9ece-d63b9a9b0d23")
	)
	(wire
		(pts
			(xy 232.41 166.37) (xy 228.6 166.37)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "62818f14-667e-42fe-81b5-1cf1d25b04d5")
	)
	(wire
		(pts
			(xy 58.42 106.68) (xy 45.72 106.68)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "642f4d3b-bb78-49fe-883b-fdbee5d821c6")
	)
	(wire
		(pts
			(xy 128.27 59.69) (xy 156.21 59.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "65c50685-dfcb-40f3-8222-82e510ed759c")
	)
	(wire
		(pts
			(xy 25.4 156.21) (xy 33.02 156.21)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "67e79c25-08fd-4f2f-8a30-9a8a0f557da2")
	)
	(wire
		(pts
			(xy 48.26 163.83) (xy 48.26 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "6881ade0-1b72-41a3-9a35-7a9db7beb8cb")
	)
	(wire
		(pts
			(xy 218.44 185.42) (xy 218.44 187.96)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "6937f792-adb6-4e79-ad0c-3a6cb9d6ec85")
	)
	(wire
		(pts
			(xy 127 48.26) (xy 147.32 48.26)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "6a2dd90f-39d2-4d8f-ac68-e4104baaec7d")
	)
	(wire
		(pts
			(xy 346.71 158.75) (xy 350.52 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "6a6d890e-5b6b-48a8-9617-5ed75bd05e3e")
	)
	(wire
		(pts
			(xy 321.31 130.81) (xy 321.31 125.73)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "6c4d81bd-22da-4ee0-b218-c34e1759423f")
	)
	(wire
		(pts
			(xy 299.72 91.44) (xy 299.72 130.81)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "6f5c7ec8-6ccb-444e-a58d-956c8c6db9ab")
	)
	(wire
		(pts
			(xy 323.85 143.51) (xy 350.52 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "703fe81d-b13d-46ab-81b8-153bc63c101c")
	)
	(wire
		(pts
			(xy 379.73 121.92) (xy 374.65 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "704627c0-a35f-420a-a53b-a17adbfad187")
	)
	(wire
		(pts
			(xy 243.84 158.75) (xy 210.82 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "71c516fc-348e-4565-a581-e558021ce02e")
	)
	(wire
		(pts
			(xy 76.2 127) (xy 66.04 127)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "72362ed5-fbe8-4a05-a372-3a7e9077ed59")
	)
	(wire
		(pts
			(xy 193.04 101.6) (xy 199.39 101.6)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "73788952-2443-46ac-9648-95520ddf9c82")
	)
	(wire
		(pts
			(xy 92.71 196.85) (xy 92.71 205.74)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "739d195f-bb05-4edc-a6b4-3d15c7667c01")
	)
	(wire
		(pts
			(xy 212.09 161.29) (xy 243.84 161.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "73f41223-b662-44e8-98ba-c8814f221a65")
	)
	(wire
		(pts
			(xy 242.57 130.81) (xy 242.57 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7425285f-eb13-4011-bc8b-ac434227b765")
	)
	(wire
		(pts
			(xy 99.06 185.42) (xy 100.33 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "748c6e7a-d41f-4806-ab32-68f87a3ff696")
	)
	(wire
		(pts
			(xy 289.56 133.35) (xy 289.56 132.08)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "753d2882-8dba-4259-b7f6-c63981818163")
	)
	(wire
		(pts
			(xy 219.71 185.42) (xy 218.44 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "756deb55-10d2-45c7-95f6-3c4976c1e49e")
	)
	(wire
		(pts
			(xy 168.91 109.22) (xy 170.18 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "75e7e4d9-4ca5-41e2-9f9d-83f41e803f18")
	)
	(wire
		(pts
			(xy 106.68 59.69) (xy 128.27 59.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "77cfe92e-c1a6-48ea-8dd0-35405eba2b94")
	)
	(wire
		(pts
			(xy 180.34 100.33) (xy 163.83 100.33)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "77d05601-5e65-4c97-8740-2b6f27e93de1")
	)
	(wire
		(pts
			(xy 76.2 49.53) (xy 74.93 49.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7893c012-fa08-4f0f-a8c0-867e899b8169")
	)
	(wire
		(pts
			(xy 307.34 53.34) (xy 307.34 88.9)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7968c69e-c743-40d3-91a9-705d4e7eddb3")
	)
	(wire
		(pts
			(xy 124.46 34.29) (xy 124.46 29.21)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7976653f-eab5-4533-88c3-4829701d8c4b")
	)
	(wire
		(pts
			(xy 114.3 196.85) (xy 116.84 196.85)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7a5c247c-10ee-4548-a9fa-a16947832d76")
	)
	(wire
		(pts
			(xy 121.92 33.02) (xy 132.08 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7bcae4e3-db98-4941-9dc9-24db81770822")
	)
	(wire
		(pts
			(xy 289.56 135.89) (xy 295.91 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7bdbde67-8443-44bc-9ea1-68351cc688eb")
	)
	(wire
		(pts
			(xy 302.26 166.37) (xy 289.56 166.37)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7c4ad972-d301-48e0-b00e-b646b9677466")
	)
	(wire
		(pts
			(xy 233.68 153.67) (xy 233.68 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "7f5987d8-81e3-4618-a9de-e0f3a321f2ba")
	)
	(wire
		(pts
			(xy 186.69 99.06) (xy 186.69 100.33)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "80e2fe0b-fd34-4b36-ba7a-925e8c4693d3")
	)
	(wire
		(pts
			(xy 157.48 33.02) (xy 167.64 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "80e9b5e6-b252-40a9-9cf6-570a02497d42")
	)
	(wire
		(pts
			(xy 119.38 34.29) (xy 116.84 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8118af94-8eb2-47b6-b110-8526439275bf")
	)
	(wire
		(pts
			(xy 86.36 49.53) (xy 87.63 49.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "81f84fa8-b079-4b03-9b59-84fc9facc152")
	)
	(wire
		(pts
			(xy 219.71 138.43) (xy 226.06 138.43)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "84a7c3f0-8f73-4f1d-9bc8-959edc771a93")
	)
	(wire
		(pts
			(xy 285.75 120.65) (xy 285.75 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "84cda8ca-b2de-4203-8ef9-a94d0c40597b")
	)
	(wire
		(pts
			(xy 52.07 135.89) (xy 52.07 128.27)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "85195f26-a83f-45cd-bb84-ef87dfd818f7")
	)
	(wire
		(pts
			(xy 226.06 140.97) (xy 238.76 140.97)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "852a0252-044e-47a3-a7a4-e919026cc591")
	)
	(wire
		(pts
			(xy 299.72 130.81) (xy 321.31 130.81)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8612b936-c99c-4275-a799-447a9f6e901a")
	)
	(wire
		(pts
			(xy 162.56 158.75) (xy 162.56 137.16)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "861d0feb-19b0-4337-a196-14a57240be65")
	)
	(wire
		(pts
			(xy 295.91 135.89) (xy 295.91 156.21)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "86320a34-f1bd-4446-979d-72e42c2ad13c")
	)
	(wire
		(pts
			(xy 30.48 151.13) (xy 30.48 163.83)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8659bfa6-2f39-4698-b19f-f76b1d29a26a")
	)
	(wire
		(pts
			(xy 66.04 116.84) (xy 62.23 116.84)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "878aebb0-9fa2-45bc-be8c-6d9aba1c897d")
	)
	(wire
		(pts
			(xy 96.52 185.42) (xy 99.06 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8a82fa83-7759-458e-b640-34365970833f")
	)
	(wire
		(pts
			(xy 165.1 34.29) (xy 165.1 17.78)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8b845dfa-7c5f-4ecd-89ee-dfdc44a89abd")
	)
	(wire
		(pts
			(xy 157.48 34.29) (xy 157.48 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8e2ebeb4-cf03-4a44-af59-303df7e4ca20")
	)
	(wire
		(pts
			(xy 45.72 148.59) (xy 53.34 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8e62a550-3f6b-4567-929d-cc5cabe2f3cc")
	)
	(wire
		(pts
			(xy 311.15 113.03) (xy 311.15 148.59)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8f492b13-8a34-4338-9d4a-36c8cd9bfecf")
	)
	(wire
		(pts
			(xy 157.48 91.44) (xy 299.72 91.44)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8fa90e24-2681-40d9-b2cf-76c69082946e")
	)
	(wire
		(pts
			(xy 157.48 129.54) (xy 165.1 129.54)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8fc0482e-ad8f-42d9-926c-fb40ba4d9c65")
	)
	(wire
		(pts
			(xy 85.09 194.31) (xy 85.09 193.04)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "8fe401fa-9b8a-4213-a081-fd3e3fb293d7")
	)
	(wire
		(pts
			(xy 364.49 158.75) (xy 350.52 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "908bda75-360d-4eb2-8538-29234594fb39")
	)
	(wire
		(pts
			(xy 76.2 101.6) (xy 71.12 101.6)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "91621a4d-add6-47e0-8865-2ea8c188d3aa")
	)
	(wire
		(pts
			(xy 102.87 74.93) (xy 110.49 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9323aaa9-db40-42df-97ca-3a5785cc487c")
	)
	(wire
		(pts
			(xy 102.87 59.69) (xy 106.68 59.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9430dcce-039c-4b12-8363-d899dd5aa5de")
	)
	(wire
		(pts
			(xy 86.36 34.29) (xy 86.36 39.37)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "948598e6-7e4a-48c1-be27-d65fa780d2f7")
	)
	(wire
		(pts
			(xy 144.78 74.93) (xy 156.21 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "94cd598c-9d08-450f-b9f2-5cec5820cd87")
	)
	(wire
		(pts
			(xy 45.72 135.89) (xy 52.07 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "95da7990-263e-4981-8c51-7449e405aef3")
	)
	(wire
		(pts
			(xy 337.82 130.81) (xy 331.47 130.81)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9636f00a-a638-48f8-93bc-8b59e6b7df13")
	)
	(wire
		(pts
			(xy 69.85 186.69) (xy 69.85 196.85)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "96a17716-9e4a-4ba8-ad8e-4cc73f49de08")
	)
	(wire
		(pts
			(xy 157.48 104.14) (xy 163.83 104.14)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9792b94b-2280-4a4d-b587-9d68e2bad7e5")
	)
	(wire
		(pts
			(xy 241.3 151.13) (xy 243.84 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "993d4d52-b9bf-4712-9226-8be7152cc735")
	)
	(wire
		(pts
			(xy 54.61 116.84) (xy 62.23 116.84)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "998c838f-87db-48d0-b4d9-45adb74c9dec")
	)
	(wire
		(pts
			(xy 379.73 137.16) (xy 355.6 137.16)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "99c6d36c-7e75-45cb-b3cb-80b3d4b4e774")
	)
	(wire
		(pts
			(xy 121.92 168.91) (xy 121.92 163.83)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9a80eaf2-4c37-4b73-8eb5-6aea81389ac7")
	)
	(wire
		(pts
			(xy 243.84 143.51) (xy 241.3 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9aea1816-fd59-48a2-8842-ff1f5afc5b57")
	)
	(wire
		(pts
			(xy 33.02 143.51) (xy 30.48 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9b875f09-e388-47ca-b2ea-8402c79964ca")
	)
	(wire
		(pts
			(xy 66.04 196.85) (xy 69.85 196.85)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9be7b6f0-b0a3-43c4-b0e8-17c4676b7b6a")
	)
	(wire
		(pts
			(xy 350.52 137.16) (xy 350.52 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9bf726cc-3bf0-4662-a0b2-da56b543b9df")
	)
	(wire
		(pts
			(xy 331.47 125.73) (xy 365.76 125.73)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9cfb8ff6-9fbc-49e8-b1c3-90f7e7773b33")
	)
	(wire
		(pts
			(xy 99.06 66.04) (xy 99.06 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9d9342d2-b763-4f8f-8bfe-b9f0cfab3ec7")
	)
	(wire
		(pts
			(xy 163.83 100.33) (xy 163.83 104.14)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9e76325d-424a-46bb-be0d-a7b460cf8f54")
	)
	(wire
		(pts
			(xy 25.4 146.05) (xy 33.02 146.05)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9eee20ee-2899-48f0-a8e3-1292347ba8e5")
	)
	(wire
		(pts
			(xy 199.39 195.58) (xy 205.74 195.58)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9f412e50-8476-42ee-8884-d0885171f51b")
	)
	(wire
		(pts
			(xy 92.71 205.74) (xy 90.17 205.74)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "9fbde791-7a73-4629-a570-33116bdf223a")
	)
	(wire
		(pts
			(xy 374.65 151.13) (xy 377.19 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a092d4a3-20fa-44d4-89e5-d118960d05e2")
	)
	(wire
		(pts
			(xy 82.55 185.42) (xy 85.09 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a0e0db0f-e11b-4132-b598-b6a2787850ca")
	)
	(wire
		(pts
			(xy 167.64 163.83) (xy 167.64 132.08)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a127c6b3-ba34-484c-9c7c-3d989e3a9765")
	)
	(wire
		(pts
			(xy 33.02 151.13) (xy 30.48 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a317f7c0-5cd4-49d6-896b-be6ec247c5df")
	)
	(wire
		(pts
			(xy 289.56 146.05) (xy 290.83 146.05)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a335d617-a587-48a8-8989-fcbd416a4a2e")
	)
	(wire
		(pts
			(xy 78.74 26.67) (xy 78.74 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a3b07e2a-269e-4944-ab1a-bd7d10f7587e")
	)
	(wire
		(pts
			(xy 208.28 195.58) (xy 212.09 195.58)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a3b9ac6f-ed04-4ca3-a334-9ee2bc4dbe15")
	)
	(wire
		(pts
			(xy 163.83 106.68) (xy 157.48 106.68)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a46ed541-558d-4d09-ae78-9903756e9ae2")
	)
	(wire
		(pts
			(xy 243.84 163.83) (xy 218.44 163.83)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a4786e21-4c60-4651-8b72-96f7b0cf377f")
	)
	(wire
		(pts
			(xy 116.84 34.29) (xy 99.06 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a5cf8e21-cef0-4b1c-ab9f-8eca4d587b5b")
	)
	(wire
		(pts
			(xy 73.66 119.38) (xy 76.2 119.38)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a600240f-4ecf-4550-b499-30d846031945")
	)
	(wire
		(pts
			(xy 99.06 158.75) (xy 162.56 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a87dde75-cd75-41dc-834a-277f0edda84a")
	)
	(wire
		(pts
			(xy 144.78 67.31) (xy 146.05 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a8a61e95-14ec-493e-8cf0-c0f19674ba25")
	)
	(wire
		(pts
			(xy 162.56 227.33) (xy 162.56 224.79)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "a9f513f7-25c1-4d87-b3dd-e3fa132a569c")
	)
	(wire
		(pts
			(xy 99.06 74.93) (xy 102.87 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "aa5125e4-b780-4f73-ae19-1d3f4b56e3bf")
	)
	(wire
		(pts
			(xy 116.84 204.47) (xy 93.98 204.47)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ab94f976-0157-45e6-8dff-5d88281aa26b")
	)
	(wire
		(pts
			(xy 66.04 116.84) (xy 66.04 124.46)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "abcbea7c-7339-46e0-bbe5-9965f4e5823c")
	)
	(wire
		(pts
			(xy 124.46 53.34) (xy 121.92 53.34)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ad85a9e2-ab4c-4943-b2a5-90757b603293")
	)
	(wire
		(pts
			(xy 219.71 130.81) (xy 226.06 130.81)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "af7d662a-83d7-429f-bbc2-7c97442971c5")
	)
	(wire
		(pts
			(xy 132.08 34.29) (xy 132.08 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "af857091-4807-4d0b-b835-fb4363b36ae5")
	)
	(wire
		(pts
			(xy 69.85 185.42) (xy 69.85 186.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "af8dc863-47e9-4f14-b6b8-fb6da84c7468")
	)
	(wire
		(pts
			(xy 71.12 88.9) (xy 307.34 88.9)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "afb03e71-054c-43df-9aa7-667baa9011e7")
	)
	(wire
		(pts
			(xy 85.09 44.45) (xy 86.36 44.45)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b0b12322-8008-4ff6-9e6e-982bae2827a4")
	)
	(wire
		(pts
			(xy 201.93 101.6) (xy 201.93 119.38)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b1ce8aff-65de-47ef-a5ea-356fee2c6a1a")
	)
	(wire
		(pts
			(xy 86.36 39.37) (xy 85.09 39.37)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b23935c1-fff9-4afc-95f7-df2c9feda706")
	)
	(wire
		(pts
			(xy 132.08 33.02) (xy 139.7 33.02)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b36fb8bf-a7fa-4c04-b5a0-76225389c35f")
	)
	(wire
		(pts
			(xy 240.03 171.45) (xy 240.03 173.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b3a0725f-a251-4994-bdcf-0a2f1f460508")
	)
	(wire
		(pts
			(xy 45.72 158.75) (xy 53.34 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b40023a0-d1e7-4e96-923a-858315ca59e6")
	)
	(wire
		(pts
			(xy 156.21 64.77) (xy 156.21 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b48f4fd0-8261-4b68-8588-61c9a90b2f47")
	)
	(wire
		(pts
			(xy 45.72 151.13) (xy 48.26 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b4914de9-96a7-4568-97fb-95f5ed43971a")
	)
	(wire
		(pts
			(xy 241.3 152.4) (xy 241.3 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b52b25f8-6d01-4a2f-840f-265b5ee025e0")
	)
	(wire
		(pts
			(xy 289.56 151.13) (xy 299.72 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b5714f9c-a862-44a8-b475-df13827c89fa")
	)
	(wire
		(pts
			(xy 171.45 67.31) (xy 173.99 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b5b2bcf7-e123-40e4-9901-daeaa2fa7486")
	)
	(wire
		(pts
			(xy 25.4 140.97) (xy 33.02 140.97)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b6065093-4b6e-489f-b223-a98ea39f6e2c")
	)
	(wire
		(pts
			(xy 318.77 135.89) (xy 332.74 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b6249bdb-62ad-44a1-8d0f-547fe05c4a79")
	)
	(wire
		(pts
			(xy 205.74 184.15) (xy 205.74 187.96)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b6de362d-1f5c-4983-9ebc-a91b0b4eaac0")
	)
	(wire
		(pts
			(xy 307.34 53.34) (xy 160.02 53.34)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b70014db-da4d-40d2-bbf3-a8fe9ca742d3")
	)
	(wire
		(pts
			(xy 295.91 110.49) (xy 295.91 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b7fc7376-01e2-4d4e-a028-93cc9de13f27")
	)
	(wire
		(pts
			(xy 118.11 64.77) (xy 118.11 67.31)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b8f56abd-b16a-4489-8f21-7294c00047ce")
	)
	(wire
		(pts
			(xy 66.04 104.14) (xy 76.2 104.14)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b97799d7-7afa-4e8c-9b91-ac685f6030bc")
	)
	(wire
		(pts
			(xy 129.54 17.78) (xy 46.99 17.78)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "b9ad64c8-fb88-4e9a-bfa5-fd133f310009")
	)
	(wire
		(pts
			(xy 116.84 186.69) (xy 116.84 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "baabd108-a9a7-47c4-b005-9790f88a4609")
	)
	(wire
		(pts
			(xy 238.76 140.97) (xy 241.3 140.97)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "bb717482-719a-42f0-8ed1-2b0b56fbbe05")
	)
	(wire
		(pts
			(xy 226.06 130.81) (xy 242.57 130.81)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "bbf2d8a5-a181-47af-874c-437bf1b73206")
	)
	(wire
		(pts
			(xy 152.4 33.02) (xy 152.4 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "bc6e3130-8be1-4c19-8343-5d18c681ddfc")
	)
	(wire
		(pts
			(xy 72.39 161.29) (xy 72.39 168.91)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "be2efadf-3924-495d-b9ca-8fb742f04083")
	)
	(wire
		(pts
			(xy 318.77 143.51) (xy 323.85 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "be2f4a40-e1e1-40cf-8094-cbb48b4de52e")
	)
	(wire
		(pts
			(xy 165.1 129.54) (xy 165.1 161.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c015fd88-2d45-425e-9873-998e402dd879")
	)
	(wire
		(pts
			(xy 129.54 34.29) (xy 129.54 17.78)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c01d5b02-1cb0-412e-9928-8e3e857f0ad7")
	)
	(wire
		(pts
			(xy 226.06 138.43) (xy 232.41 138.43)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c076a3cd-524d-467b-8280-7b8557fa7014")
	)
	(wire
		(pts
			(xy 45.72 106.68) (xy 45.72 16.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c2b65477-10b2-4eed-a630-ae7264c51933")
	)
	(wire
		(pts
			(xy 302.26 133.35) (xy 323.85 133.35)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c2f64f09-5f42-4b9f-af7a-e14147f8ff62")
	)
	(wire
		(pts
			(xy 62.23 34.29) (xy 74.93 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c397aa3a-be6b-42db-92ec-dfd6c2c8e8e5")
	)
	(wire
		(pts
			(xy 201.93 101.6) (xy 199.39 101.6)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c51ed3f9-ad1b-4b81-99cb-6f6ba660b2fe")
	)
	(wire
		(pts
			(xy 82.55 176.53) (xy 82.55 177.8)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c56d6272-9b89-4305-9e79-a2dce8cc1739")
	)
	(wire
		(pts
			(xy 48.26 151.13) (xy 48.26 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c6291d16-739e-4944-9c3d-e9851c169476")
	)
	(wire
		(pts
			(xy 238.76 121.92) (xy 285.75 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c7b6bd12-7691-45fc-a8e1-b493e0898e2e")
	)
	(wire
		(pts
			(xy 163.83 74.93) (xy 173.99 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c7c2aef3-e561-4ff2-be3f-3a104e0096f7")
	)
	(wire
		(pts
			(xy 209.55 175.26) (xy 199.39 175.26)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c8341aa6-aeb3-4a74-8419-47919ab68d98")
	)
	(wire
		(pts
			(xy 186.69 100.33) (xy 186.69 101.6)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "c88213bb-165c-40f0-b0d9-60bdc282cf4a")
	)
	(wire
		(pts
			(xy 175.26 109.22) (xy 170.18 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ca2e3198-fbc9-4735-bb50-97562e984692")
	)
	(wire
		(pts
			(xy 198.12 185.42) (xy 199.39 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "cb3677e2-cbb9-469e-a330-251d26038e46")
	)
	(wire
		(pts
			(xy 240.03 173.99) (xy 237.49 173.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "cbdc8b3d-c986-40f1-bb95-252bf77f1e56")
	)
	(wire
		(pts
			(xy 104.14 186.69) (xy 116.84 186.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "cc4235ca-59bd-4056-ad44-bee4e7626d63")
	)
	(wire
		(pts
			(xy 121.92 163.83) (xy 167.64 163.83)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ccaef0b1-29e9-4176-af84-d3bd6b1a37a9")
	)
	(wire
		(pts
			(xy 311.15 158.75) (xy 346.71 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "cd0a05ad-a57b-44ca-9578-7e3de9d23771")
	)
	(wire
		(pts
			(xy 194.31 99.06) (xy 186.69 99.06)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "cdeb41dc-c3c0-4619-9bfb-56592344a249")
	)
	(wire
		(pts
			(xy 99.06 176.53) (xy 99.06 177.8)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ce419fdf-4aa2-4009-88ca-f42b535c2db5")
	)
	(wire
		(pts
			(xy 213.36 187.96) (xy 212.09 187.96)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ce6f6f12-28f0-4166-904c-f2e07462ed19")
	)
	(wire
		(pts
			(xy 76.2 124.46) (xy 66.04 124.46)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "cf1e02d1-0d6b-49ab-9628-7d4d9c8095d0")
	)
	(wire
		(pts
			(xy 377.19 139.7) (xy 337.82 139.7)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "cfd9e190-9ec5-4b93-901f-f6b7c20acd26")
	)
	(wire
		(pts
			(xy 170.18 121.92) (xy 170.18 127)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d01ebfb2-b731-4ff5-804f-aafac7d9208e")
	)
	(wire
		(pts
			(xy 323.85 140.97) (xy 323.85 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d033b6af-265b-41bf-a570-bf9ee629b20f")
	)
	(wire
		(pts
			(xy 240.03 168.91) (xy 240.03 171.45)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d03aa4b4-d8c3-4184-ab95-ce2a457e3cb1")
	)
	(wire
		(pts
			(xy 379.73 132.08) (xy 379.73 137.16)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d06cd394-7ca2-412c-9ad7-73d28b18d3c7")
	)
	(wire
		(pts
			(xy 72.39 176.53) (xy 72.39 177.8)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d1279e36-30f4-43c9-b29e-9c3bd6f378bc")
	)
	(wire
		(pts
			(xy 46.99 111.76) (xy 45.72 111.76)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d2a36a60-9968-4d0d-87c5-6b6da6720168")
	)
	(wire
		(pts
			(xy 167.64 46.99) (xy 165.1 46.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d2ec783d-da17-4189-9491-a53ed2ad5847")
	)
	(wire
		(pts
			(xy 163.83 104.14) (xy 163.83 106.68)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d38ff019-a10d-4b13-b508-90136fd29b69")
	)
	(wire
		(pts
			(xy 71.12 101.6) (xy 71.12 88.9)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d409a4b2-dd99-4d1a-b587-00d86f836d9f")
	)
	(wire
		(pts
			(xy 110.49 74.93) (xy 119.38 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d4887f81-0991-4eb6-8f7f-38dea2affde9")
	)
	(wire
		(pts
			(xy 62.23 41.91) (xy 62.23 49.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d51a78f2-9407-4c2c-aecd-e18c04579069")
	)
	(wire
		(pts
			(xy 78.74 34.29) (xy 74.93 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d68f81be-e2cf-491b-95de-fbfccf6390ef")
	)
	(wire
		(pts
			(xy 62.23 49.53) (xy 74.93 49.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d6b587f2-9bb8-4ee4-afc8-e0e829f3255b")
	)
	(wire
		(pts
			(xy 165.1 111.76) (xy 165.1 101.6)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d6cdb7df-2663-48db-9f17-47d4c297996a")
	)
	(wire
		(pts
			(xy 241.3 153.67) (xy 243.84 153.67)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d6e0a43c-ebc4-4b4a-b404-d8131a06d7a1")
	)
	(wire
		(pts
			(xy 156.21 74.93) (xy 163.83 74.93)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d7a83dfb-d089-4eb1-917e-cff0611dca0b")
	)
	(wire
		(pts
			(xy 242.57 146.05) (xy 243.84 146.05)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d89883c4-2bcb-461c-999f-25464db0be53")
	)
	(wire
		(pts
			(xy 294.64 158.75) (xy 311.15 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "d90b4dfd-b21a-4db6-a2cf-c4049bb99c67")
	)
	(wire
		(pts
			(xy 157.48 101.6) (xy 157.48 91.44)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "da963ca3-efbc-4a4d-8ce1-0c0fb12e38cc")
	)
	(wire
		(pts
			(xy 116.84 185.42) (xy 121.92 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "dc592f6a-e8cc-4f98-a14b-b771fa120c04")
	)
	(wire
		(pts
			(xy 78.74 33.02) (xy 78.74 34.29)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "dcf0e619-8736-4a2a-a8ad-7ddecb423f88")
	)
	(wire
		(pts
			(xy 243.84 133.35) (xy 243.84 110.49)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "dd1c7235-bed6-4040-8fa1-4ef07cadb608")
	)
	(wire
		(pts
			(xy 355.6 121.92) (xy 374.65 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "dfcf0ca9-577e-4924-a7fa-e3b9d1dc2e93")
	)
	(wire
		(pts
			(xy 289.56 171.45) (xy 292.1 171.45)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e1a87746-85d3-46f9-be18-6ff304d32a15")
	)
	(wire
		(pts
			(xy 99.06 59.69) (xy 102.87 59.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e3b4448f-1c97-42ea-b36e-38566f17f0e1")
	)
	(wire
		(pts
			(xy 69.85 185.42) (xy 72.39 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e472467c-3362-4d39-ad30-64bb46b363da")
	)
	(wire
		(pts
			(xy 299.72 151.13) (xy 299.72 130.81)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e57701f2-272f-49f0-8cff-abe3bab657e3")
	)
	(wire
		(pts
			(xy 166.37 121.92) (xy 166.37 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e579d5c6-11d1-41c9-a55b-20dbe6a00cdb")
	)
	(wire
		(pts
			(xy 377.19 151.13) (xy 377.19 139.7)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e59ef82a-cbbd-4fb8-b257-65bf487f9a10")
	)
	(wire
		(pts
			(xy 210.82 158.75) (xy 210.82 176.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e5c68297-dab7-4db4-b314-a81a258557b7")
	)
	(wire
		(pts
			(xy 214.63 140.97) (xy 226.06 140.97)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e6993929-503e-46a5-8e1b-9c541a9813e6")
	)
	(wire
		(pts
			(xy 128.27 67.31) (xy 128.27 64.77)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e6e5d442-4315-4649-baf3-30f3974015ae")
	)
	(wire
		(pts
			(xy 236.22 121.92) (xy 238.76 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e7193f1e-6017-45ab-ad61-33d7f6865e35")
	)
	(wire
		(pts
			(xy 76.2 106.68) (xy 66.04 106.68)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e728da2a-1bbc-45c9-a809-e4aacb5d4373")
	)
	(wire
		(pts
			(xy 160.02 53.34) (xy 160.02 46.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e790e4d4-de6f-4b98-a5bc-76c2a01d3139")
	)
	(wire
		(pts
			(xy 307.34 138.43) (xy 289.56 138.43)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e80fd360-93dd-4549-9ade-bd86760fb5fa")
	)
	(wire
		(pts
			(xy 30.48 163.83) (xy 30.48 165.1)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e89b0aed-40c1-4600-b19c-300547d8f8e3")
	)
	(wire
		(pts
			(xy 45.72 146.05) (xy 53.34 146.05)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e9640ca8-4bdf-45b9-8159-c56ee0481cf0")
	)
	(wire
		(pts
			(xy 163.83 160.02) (xy 163.83 134.62)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "e9c40bd4-3b75-43cc-b239-6802f50aa364")
	)
	(wire
		(pts
			(xy 85.09 185.42) (xy 87.63 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "eb392d70-ad07-4473-b459-eaeac4c25eda")
	)
	(wire
		(pts
			(xy 237.49 166.37) (xy 232.41 166.37)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ebd5282c-d333-4b46-a7dc-c0f61622846b")
	)
	(wire
		(pts
			(xy 374.65 143.51) (xy 364.49 143.51)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ecf554fa-22fc-40dc-a640-51573c5c7bb7")
	)
	(wire
		(pts
			(xy 168.91 115.57) (xy 168.91 116.84)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ed0d47b1-ad6f-4386-8302-4601671343d1")
	)
	(wire
		(pts
			(xy 167.64 132.08) (xy 157.48 132.08)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ee111728-731c-44c7-9b5c-4f501e185399")
	)
	(wire
		(pts
			(xy 95.25 49.53) (xy 96.52 49.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "eee4931a-8f4f-4ceb-8614-c5aca8eec0be")
	)
	(wire
		(pts
			(xy 25.4 138.43) (xy 33.02 138.43)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "eefaa715-203f-4d31-8f49-09cfc3708b74")
	)
	(wire
		(pts
			(xy 289.56 173.99) (xy 292.1 173.99)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f1adba9e-ec40-42b8-8a0d-3d8a8742cc43")
	)
	(wire
		(pts
			(xy 25.4 135.89) (xy 27.94 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f2c900ea-b31d-4753-a9b2-dafb4a3beb16")
	)
	(wire
		(pts
			(xy 45.72 140.97) (xy 53.34 140.97)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f2f7ee80-9a3a-40fb-b207-7c2175843181")
	)
	(wire
		(pts
			(xy 180.34 109.22) (xy 186.69 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f3892ad2-af38-4985-903b-06789045773e")
	)
	(wire
		(pts
			(xy 116.84 196.85) (xy 116.84 204.47)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f3ae5a35-d070-455c-9d27-64789a557c46")
	)
	(wire
		(pts
			(xy 180.34 109.22) (xy 177.8 109.22)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f3b500b5-c426-46e8-b3bb-675de8a6c4ae")
	)
	(wire
		(pts
			(xy 243.84 168.91) (xy 240.03 168.91)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f3d1fb3b-fc65-4181-9c42-2438e468ce55")
	)
	(wire
		(pts
			(xy 66.04 86.36) (xy 311.15 86.36)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f3f6e47e-a919-4e52-8e57-6abe48565c63")
	)
	(wire
		(pts
			(xy 289.56 158.75) (xy 294.64 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f418770e-6a9d-42d4-89a2-d27b4c174730")
	)
	(wire
		(pts
			(xy 302.26 153.67) (xy 302.26 133.35)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f41c6029-4be8-49cb-a6d1-46a34a25dc5a")
	)
	(wire
		(pts
			(xy 127 46.99) (xy 127 48.26)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f44aec27-25b5-4cf1-80b7-f2afbc78a589")
	)
	(wire
		(pts
			(xy 218.44 184.15) (xy 218.44 185.42)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f44ff315-1379-4bc3-9386-2d11f6ce2117")
	)
	(wire
		(pts
			(xy 337.82 139.7) (xy 337.82 130.81)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f58e6464-d7b5-412e-a58f-074f20179bfa")
	)
	(wire
		(pts
			(xy 240.03 144.78) (xy 242.57 144.78)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f5a6dfe1-483c-48f1-9788-d2045ea99bdc")
	)
	(wire
		(pts
			(xy 52.07 128.27) (xy 27.94 128.27)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f656c901-1725-43f6-8d43-485dcae9d17f")
	)
	(wire
		(pts
			(xy 116.84 196.85) (xy 116.84 186.69)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f66599e8-91f5-47be-bb8a-7bdfb3326a6b")
	)
	(wire
		(pts
			(xy 30.48 143.51) (xy 30.48 151.13)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f6b4f4e7-fbe2-4f9e-9b50-0ba6e2134e93")
	)
	(wire
		(pts
			(xy 210.82 176.53) (xy 205.74 176.53)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "f6eb7d0b-2d6a-47b8-9b75-c226742b2789")
	)
	(wire
		(pts
			(xy 88.9 41.91) (xy 87.63 41.91)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "fb355b5f-137e-4a1b-91c4-3e7b9515e179")
	)
	(wire
		(pts
			(xy 307.34 88.9) (xy 307.34 105.41)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "fbf2ab1a-d0da-49ea-baec-937364cac818")
	)
	(wire
		(pts
			(xy 27.94 135.89) (xy 33.02 135.89)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "fc6104bc-4f4f-4de6-8f55-441d7b62f123")
	)
	(wire
		(pts
			(xy 285.75 121.92) (xy 355.6 121.92)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "fcd6e299-fe73-48d0-9e66-b3abb4288cbe")
	)
	(wire
		(pts
			(xy 205.74 195.58) (xy 208.28 195.58)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "fcf48b7d-8c48-481b-9dd3-db1c209b82c9")
	)
	(wire
		(pts
			(xy 180.34 100.33) (xy 186.69 100.33)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "fd839846-3a01-431e-8693-14abf3c866bc")
	)
	(wire
		(pts
			(xy 350.52 143.51) (xy 350.52 158.75)
		)
		(stroke
			(width 0)
			(type default)
		)
		(uuid "ffe42592-e933-4e57-a227-3ff6513a3178")
	)
	(global_label "ID_SC"
		(shape input)
		(at 149.86 29.21 90)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "04069deb-5dec-46f9-b4ba-8c186cd41155")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 149.86 29.21 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "gpio14"
		(shape input)
		(at 25.4 140.97 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "0701e37b-69db-4fa8-bb6a-c70fe58248cf")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 25.4 140.97 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outl+"
		(shape input)
		(at 25.4 158.75 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "09b31a12-5ede-4d62-aeaf-933f87218048")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 25.4 158.75 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "gpio15"
		(shape input)
		(at 53.34 140.97 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "0ac3dcc5-727c-4a16-8414-c8e30bfe22da")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 53.34 140.97 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "gpio15"
		(shape input)
		(at 127 29.21 90)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "0cbb7e2d-4922-4540-ae1a-5fa23b3c2995")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 127 29.21 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "micbias"
		(shape input)
		(at 53.34 153.67 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "0fc05d80-d033-4a66-bf8f-22a6f0a95762")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 53.34 153.67 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "micbias"
		(shape input)
		(at 171.45 127 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "184b31c7-9bba-4f32-b473-7bc86c7ac0bd")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 171.45 127 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outr+"
		(shape input)
		(at 25.4 156.21 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "1bcde996-d5a7-49ce-9405-2e627965adcd")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 25.4 156.21 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "sda"
		(shape input)
		(at 25.4 138.43 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "1fb869a5-9ea9-4d1d-b783-17eb00f74063")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 25.4 138.43 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "DVDD"
		(shape input)
		(at 194.31 99.06 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "24d17564-31ba-44f2-b429-a1cc2e981d36")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 194.31 99.06 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "inl+"
		(shape input)
		(at 114.3 196.85 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "297e1d1d-80a7-41d3-93f9-2bd23787b302")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 114.3 196.85 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "gpio14"
		(shape input)
		(at 124.46 29.21 90)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "2b5b16de-a6c5-4480-a12a-060c246f59b9")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 124.46 29.21 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outr+"
		(shape input)
		(at 219.71 185.42 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "3438a299-69a3-4524-834e-ba4817798a23")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 219.71 185.42 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "inl+"
		(shape input)
		(at 25.4 148.59 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "351f474a-7d61-4568-830b-158394cd12bb")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 25.4 148.59 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "ID_SC"
		(shape input)
		(at 88.9 41.91 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "37a272d1-5eeb-44fb-934d-8b8d079db2d8")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 88.9 41.91 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outr+"
		(shape input)
		(at 191.77 224.79 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "399b22ea-8ca0-4ca1-a79c-b07060ac3048")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 191.77 224.79 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outl-"
		(shape input)
		(at 53.34 158.75 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "41b9e659-efc6-4a9c-8ce9-18951cf5d319")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 53.34 158.75 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "DVDD"
		(shape input)
		(at 120.65 67.31 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "4d542d2c-f458-4f86-82c9-21a4fa205439")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 120.65 67.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "ID_SD"
		(shape input)
		(at 149.86 52.07 270)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "4e015005-98ed-476c-932d-660ac74b172a")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 149.86 52.07 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "sda"
		(shape input)
		(at 292.1 173.99 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "572314d1-8f41-49a1-ba92-2149089dc3fd")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 292.1 173.99 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "inr-"
		(shape input)
		(at 53.34 146.05 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "57289ad8-cb7d-4bb2-b249-c92f517b8197")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 53.34 146.05 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outr-"
		(shape input)
		(at 213.36 187.96 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "5a9d5cfc-4bd2-43f8-917b-7d1ea530e453")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 213.36 187.96 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "inr-"
		(shape input)
		(at 87.63 185.42 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "5f1177a3-0fde-4134-8d1e-2a7eb6922869")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 87.63 185.42 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "scl"
		(shape input)
		(at 53.34 138.43 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "62b0126c-181e-4e13-aaf9-40ece9746e41")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 53.34 138.43 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "sda"
		(shape input)
		(at 116.84 53.34 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "67334b7c-3246-4b24-a8f0-6f1ffebf31dd")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 116.84 53.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "inr+"
		(shape input)
		(at 66.04 196.85 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "73840175-c013-4f09-b59e-d8e26a998f72")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 66.04 196.85 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "inl-"
		(shape input)
		(at 100.33 185.42 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "74bdc467-8df7-49ae-b855-f32b061c39e5")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 100.33 185.42 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "DIN"
		(shape input)
		(at 290.83 146.05 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "79a33690-423f-42e6-85e5-e02d74aebf08")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 290.83 146.05 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "inr+"
		(shape input)
		(at 25.4 146.05 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "7a631388-3051-42e5-a029-b49fd58a00e9")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 25.4 146.05 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "ID_SD"
		(shape input)
		(at 88.9 39.37 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "7c1f81ab-6be9-44d0-a8cc-29ce29e8d5cd")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 88.9 39.37 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "AVDD2"
		(shape input)
		(at 146.05 67.31 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "8031ec6c-ff88-4156-8265-9e36094fc2c6")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 146.05 67.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "DVDD"
		(shape input)
		(at 236.22 121.92 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "89d051bb-f66d-4dee-85de-fecb56b76354")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 236.22 121.92 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "scl"
		(shape input)
		(at 124.46 53.34 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "93c91e58-3396-4e69-a0e7-dd89cbb7cb28")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 124.46 53.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "DIN"
		(shape input)
		(at 172.72 17.78 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "94dc4478-d8c3-4aee-871b-90018bfa24e5")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 172.72 17.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "DVDD"
		(shape input)
		(at 73.66 31.75 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "968b6f24-5f17-4f99-b602-468d9f3e4981")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 73.66 31.75 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "AVDD"
		(shape input)
		(at 177.8 67.31 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "a50be7fa-3372-443d-ab1b-eba0455d7357")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 177.8 67.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "5v"
		(shape input)
		(at 25.4 135.89 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "a7c29601-5c6d-4e26-b2d2-01410ca9f706")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 25.4 135.89 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outr-"
		(shape input)
		(at 53.34 156.21 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "abbd0d72-c2be-4dd5-b636-ab84b544db8f")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 53.34 156.21 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "scl"
		(shape input)
		(at 73.66 121.92 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "b23ea916-a5dc-4938-ac90-81632af8ad53")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 73.66 121.92 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outl+"
		(shape input)
		(at 162.56 224.79 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "b8c4a33d-ae32-401b-a830-1972f0c58461")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 162.56 224.79 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "scl"
		(shape input)
		(at 292.1 171.45 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "c06e5b16-36a9-46b4-99f7-7c295c356032")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 292.1 171.45 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outl+"
		(shape input)
		(at 198.12 185.42 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "c7452d0f-0f23-49ca-9b2c-c15ace29694a")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 198.12 185.42 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "AVDD"
		(shape input)
		(at 228.6 166.37 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "d8d3f866-2b8a-45ad-8c3f-23e9e7fe4c4a")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 228.6 166.37 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "inl-"
		(shape input)
		(at 53.34 148.59 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "db99fdbe-8206-4b7a-a871-f2a12d2fb8eb")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 53.34 148.59 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "outl-"
		(shape input)
		(at 204.47 187.96 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "e15b4977-deb8-4cf1-83a3-2b0412a41cc5")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 204.47 187.96 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "5v"
		(shape input)
		(at 99.06 53.34 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "e3dc3638-9695-4ce6-832d-83af3b3de09d")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 99.06 53.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "sda"
		(shape input)
		(at 73.66 119.38 180)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify right)
		)
		(uuid "f6c4042e-893f-4f95-b39c-056f30288f06")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 73.66 119.38 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(global_label "AVDD2"
		(shape input)
		(at 204.47 101.6 0)
		(effects
			(font
				(size 1.27 1.27)
			)
			(justify left)
		)
		(uuid "fdc2e0c4-c452-4a7a-be81-66e4dad224d7")
		(property "Intersheetrefs" "${INTERSHEET_REFS}"
			(at 204.47 101.6 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
	)
	(symbol
		(lib_id "zynthiandac-rescue:PCM1863DBT-pcm1863")
		(at 157.48 137.16 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f73ce71")
		(property "Reference" "U1"
			(at 116.84 146.9898 0)
			(effects
				(font
					(size 1.524 1.524)
				)
			)
		)
		(property "Value" "PCM1863DBT"
			(at 116.84 144.2974 0)
			(effects
				(font
					(size 1.524 1.524)
				)
			)
		)
		(property "Footprint" "pcm1863:PCM1863DBT"
			(at 116.84 143.256 0)
			(effects
				(font
					(size 1.524 1.524)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 157.48 137.16 0)
			(effects
				(font
					(size 1.524 1.524)
				)
			)
		)
		(property "Description" ""
			(at 157.48 137.16 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "19b90270-f99d-4781-abee-ac6b8b92f1af")
		)
		(pin "4"
			(uuid "691a466e-9cfb-46d2-89dd-6cc5c879cf52")
		)
		(pin "2"
			(uuid "1ac3975e-76d5-4ca2-9183-ecbf849891af")
		)
		(pin "3"
			(uuid "36a76469-eeff-430d-b1c2-6eb4062500e8")
		)
		(pin "21"
			(uuid "e0f21110-0743-406e-b744-30e8a779213f")
		)
		(pin "12"
			(uuid "f13e4e59-e003-4a8b-9752-a6f2d89fc97e")
		)
		(pin "25"
			(uuid "f8710f5e-29bc-4228-a511-7acac46d0f8d")
		)
		(pin "23"
			(uuid "85ec26dd-2277-4c49-ad29-aeb4c2d2773e")
		)
		(pin "16"
			(uuid "cff2c703-9997-46e8-99fe-fae5db0d9ffc")
		)
		(pin "9"
			(uuid "5f03b186-c599-4697-966f-d1aebfa5925c")
		)
		(pin "13"
			(uuid "5272a927-b40d-4f5c-b226-db9e9b82d48e")
		)
		(pin "14"
			(uuid "28c3aedd-0f3b-4fff-b914-a20e08a1e299")
		)
		(pin "24"
			(uuid "6aceae1d-908c-4522-a4f8-ef6f841b8c86")
		)
		(pin "10"
			(uuid "5af46b1d-aee9-4e00-b8ba-2d6dc4275259")
		)
		(pin "30"
			(uuid "70272898-f1e3-4b5c-80ea-d81e32d28c72")
		)
		(pin "22"
			(uuid "7484d1bc-0023-4954-96b8-6a3106dfada5")
		)
		(pin "5"
			(uuid "ce9d2935-171c-41f7-af0d-dbaeaccaf446")
		)
		(pin "6"
			(uuid "d7d0c413-8521-4b8b-98e7-b840c6d9dd1d")
		)
		(pin "7"
			(uuid "a4c803e7-cac6-4a5d-9c7c-f59034f142b4")
		)
		(pin "15"
			(uuid "6ef93dfb-ea49-427c-9b18-3574a2c7ba65")
		)
		(pin "8"
			(uuid "b891363c-f1a9-4db5-99b2-4ccc1d56e124")
		)
		(pin "11"
			(uuid "bda6a82b-2aae-455c-b1e7-e34221b85710")
		)
		(pin "28"
			(uuid "e7a5abc7-e91f-4087-bb42-f31ec7e10058")
		)
		(pin "29"
			(uuid "b778e9de-c515-4f40-8da8-18480d6aa2e5")
		)
		(pin "27"
			(uuid "d9ed6d7a-6fe0-479d-896b-892d90ea94d0")
		)
		(pin "26"
			(uuid "4728b27a-fd5c-4bf1-a5bc-b8b807e25efb")
		)
		(pin "20"
			(uuid "4aa9b908-af4d-47c2-bde9-ed786e99db64")
		)
		(pin "18"
			(uuid "effd023a-dfe5-4a69-be18-2eaa1cc88f3f")
		)
		(pin "19"
			(uuid "25b3fb05-9b61-45f0-84ef-ee91e8e3b36f")
		)
		(pin "17"
			(uuid "677aba41-ac46-40be-bf0d-8bfc4a8c09b7")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "U1")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 170.18 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f77db12")
		(property "Reference" "#PWR0101"
			(at 170.18 115.57 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 170.307 113.6142 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 170.18 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 170.18 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 170.18 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "f4c7b986-2964-4c58-bfbe-765aa9d0ddb8")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0101")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 62.23 123.19 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f787c8f")
		(property "Reference" "#PWR0102"
			(at 62.23 129.54 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 62.357 127.5842 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 62.23 123.19 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 62.23 123.19 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 62.23 123.19 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "37c328ce-a4c0-4026-b525-c694092d2751")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0102")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "conn_02x20:Conn_2x20")
		(at 139.7 41.91 90)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f790cfa")
		(property "Reference" "J1"
			(at 114.3 40.64 0)
			(effects
				(font
					(size 0.508 0.508)
				)
				(hide yes)
			)
		)
		(property "Value" "Conn_2x20"
			(at 167.132 40.64 90)
			(effects
				(font
					(size 0.9906 0.9906)
				)
				(justify right)
			)
		)
		(property "Footprint" "Connector_PinHeader_2.54mm:PinHeader_2x20_P2.54mm_Vertical"
			(at 139.7 41.91 0)
			(effects
				(font
					(size 0.508 0.508)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 139.7 41.91 0)
			(effects
				(font
					(size 0.508 0.508)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 139.7 41.91 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "9"
			(uuid "fec17b11-7129-4ee4-97b8-9221ebc81cfd")
		)
		(pin "3"
			(uuid "899323d7-792b-48c8-97cb-2259db79c443")
		)
		(pin "7"
			(uuid "92d24ee8-7dc7-4aa6-9615-be7591e32aa5")
		)
		(pin "5"
			(uuid "9f0f5531-8ddd-434f-a1a9-8ac2e01ca0fb")
		)
		(pin "17"
			(uuid "0f7d0de4-2f28-4447-a5ae-c9fdced1a219")
		)
		(pin "4"
			(uuid "ceb76d0a-6b9c-4e66-9fb6-108904c808fa")
		)
		(pin "19"
			(uuid "08b35e25-c237-4e12-9bf1-e84ba8c2bf73")
		)
		(pin "1"
			(uuid "8e88e47a-6095-4df1-b819-1650c7e8f4b8")
		)
		(pin "13"
			(uuid "ecd45a7a-a6b8-451c-b04d-e895cbae89bd")
		)
		(pin "23"
			(uuid "156c126f-b0e6-487f-ada8-09567f376444")
		)
		(pin "25"
			(uuid "ded63732-77a0-44cf-a8e6-ab120fc4ccf4")
		)
		(pin "27"
			(uuid "d19f94f6-50b2-4346-b481-d9def90e4e9a")
		)
		(pin "35"
			(uuid "10bcdbad-c86e-4d73-b782-70c8c0d33562")
		)
		(pin "39"
			(uuid "0dba277f-2c19-428e-9623-8b37b3b5f1f6")
		)
		(pin "20"
			(uuid "4b1686f4-5d98-4c2a-b048-75cd6a4d1804")
		)
		(pin "28"
			(uuid "45bc2586-b17b-43e0-a134-78eef12adcbb")
		)
		(pin "11"
			(uuid "6c194c69-ac4d-4f7f-8376-7825d286d958")
		)
		(pin "31"
			(uuid "92e3726b-a652-45e1-a088-e271bbe56663")
		)
		(pin "6"
			(uuid "4e461bb9-9df6-40c5-8036-7c842662222f")
		)
		(pin "29"
			(uuid "6b96aa90-b5fb-4c6f-81f7-527958f43cef")
		)
		(pin "33"
			(uuid "30aa25df-23ad-4a25-987d-545508cc5383")
		)
		(pin "15"
			(uuid "0a8ba4be-04f9-4a45-a046-0281a025116a")
		)
		(pin "2"
			(uuid "15be0215-2af9-47d6-88b0-1da9ec22655a")
		)
		(pin "8"
			(uuid "298e6502-9bdc-460b-a362-9414b45d4915")
		)
		(pin "10"
			(uuid "4a5453d7-4567-417f-a847-7199930eea17")
		)
		(pin "14"
			(uuid "9bff9a22-2e4b-4dfa-b7c9-177540455b60")
		)
		(pin "21"
			(uuid "89a12420-6a78-4084-b5ae-8d4ea3e84332")
		)
		(pin "37"
			(uuid "0591d158-1d7a-46b0-9af2-8ccf91681d6d")
		)
		(pin "16"
			(uuid "fb258b2f-78a0-447a-83a0-436730b3533d")
		)
		(pin "18"
			(uuid "dde38f82-2c8a-45f7-850c-fc2518414aab")
		)
		(pin "24"
			(uuid "98e83d1d-e793-4c55-9cff-48a3d812332e")
		)
		(pin "26"
			(uuid "1576feed-d173-4e12-97f0-203e955f8157")
		)
		(pin "22"
			(uuid "350f40f1-35d2-42a0-9805-1443c2a0959a")
		)
		(pin "30"
			(uuid "4f33568b-c010-403b-99c5-7efdf157b3f9")
		)
		(pin "32"
			(uuid "7ff46736-484e-4363-8843-fb6169140df8")
		)
		(pin "34"
			(uuid "9d9c8c1c-9f95-4983-960a-8f7c61fdeb9c")
		)
		(pin "12"
			(uuid "b1cc0081-f093-482b-a63a-c09389bc0331")
		)
		(pin "38"
			(uuid "4e923a0b-d822-4343-92f7-b4eef1336d3e")
		)
		(pin "40"
			(uuid "f135917a-48ef-478c-ab3f-52fba498655e")
		)
		(pin "36"
			(uuid "84d1bfd8-7d1f-497f-bf27-afd981156de6")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "J1")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 346.71 161.29 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f7a4cd9")
		(property "Reference" "#PWR0103"
			(at 346.71 167.64 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 346.837 165.6842 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 346.71 161.29 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 346.71 161.29 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 346.71 161.29 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "4473274e-b956-4381-a789-a0c99eaca160")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0103")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 285.75 116.84 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f7a5994")
		(property "Reference" "R1"
			(at 280.4922 116.84 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "10k"
			(at 282.8036 116.84 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 283.972 116.84 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 285.75 116.84 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 285.75 116.84 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "219a26a5-ce94-415f-960f-b75cf395bc03")
		)
		(pin "1"
			(uuid "9c338894-1f50-42b5-80c0-d35ec65d7803")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R1")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "zynthiandac-rescue:ASCO-Oscillator")
		(at 364.49 151.13 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f7ca052")
		(property "Reference" "X2"
			(at 375.7676 149.9616 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "24.576Mhz"
			(at 375.7676 152.273 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Oscillator:Oscillator_SMD_Abracon_ASDMB-4Pin_2.5x2.0mm"
			(at 367.03 160.02 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "https://abracon.com/Oscillators/ASCO.pdf"
			(at 358.775 147.955 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 364.49 151.13 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "d71b6753-adfa-4090-9b4e-baf4195db468")
		)
		(pin "3"
			(uuid "b545ab94-cfa5-455a-b850-711d6004e1c8")
		)
		(pin "2"
			(uuid "0da71dc0-f6a4-447a-baca-4b768282e3c4")
		)
		(pin "4"
			(uuid "b6ef0a58-0d35-47e5-87e6-f729fee2d837")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "X2")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "zynthiandac-rescue:ASCO-Oscillator")
		(at 355.6 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f7cbeb3")
		(property "Reference" "X1"
			(at 366.8776 128.3716 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "22.5792Mhz"
			(at 366.8776 130.683 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Oscillator:Oscillator_SMD_Abracon_ASDMB-4Pin_2.5x2.0mm"
			(at 358.14 138.43 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "https://abracon.com/Oscillators/ASCO.pdf"
			(at 349.885 126.365 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 355.6 129.54 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "88f49119-d3d0-4755-a099-277562c14ea9")
		)
		(pin "4"
			(uuid "93dd471e-fabb-42b0-8320-3d6748594c6c")
		)
		(pin "2"
			(uuid "0fe5ab9e-d978-4d30-b143-64e1aa715762")
		)
		(pin "3"
			(uuid "d6883fd8-9e8c-4a60-aaa4-24f4c6921921")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "X1")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 307.34 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8933fb")
		(property "Reference" "R25"
			(at 309.118 108.0516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100R"
			(at 309.118 110.363 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 305.562 109.22 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 307.34 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 307.34 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "d18e6535-fdbb-411c-a5a2-bd16474928ad")
		)
		(pin "1"
			(uuid "1cfccfa3-b734-4b2a-97ad-447bcd3c08ce")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R25")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 311.15 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f893b94")
		(property "Reference" "R27"
			(at 312.928 108.0516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100R"
			(at 312.928 110.363 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 309.372 109.22 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 311.15 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 311.15 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "4bcd2551-fbea-4a19-8c15-a608a79b20a4")
		)
		(pin "2"
			(uuid "ca330ade-598f-45c3-a488-29126b52f23d")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R27")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:LED")
		(at 50.8 111.76 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8a3acf")
		(property "Reference" "D1"
			(at 50.6222 106.2736 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "LED"
			(at 50.6222 108.585 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "zynthiandac:led_0806"
			(at 50.8 111.76 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 50.8 111.76 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 50.8 111.76 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "645369f9-0fa1-4945-b594-09377ee7dad9")
		)
		(pin "1"
			(uuid "3afee330-a317-4711-aa16-ebf12626ad8a")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "D1")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 50.8 116.84 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8a64bf")
		(property "Reference" "R2"
			(at 50.8 111.5822 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "10k"
			(at 50.8 113.8936 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 50.8 115.062 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 50.8 116.84 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 50.8 116.84 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "5a949531-6ba2-46b8-8556-4445fef8f3a8")
		)
		(pin "1"
			(uuid "5c8e9a30-3f11-4ea2-97e1-1d8510e239c0")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R2")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 72.39 181.61 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8c50b5")
		(property "Reference" "C1"
			(at 75.311 180.4416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 75.311 182.753 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 73.3552 185.42 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 72.39 181.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 72.39 181.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "fd3ff22d-6dc1-459f-895a-b3624a9c713f")
		)
		(pin "1"
			(uuid "8a9abbe1-3577-43bc-955b-d5b692491121")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C1")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "zynthiandac-rescue:PCM5242RHBR-pcm5242")
		(at 243.84 133.35 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8cfd7b")
		(property "Reference" "U6"
			(at 266.7 123.5202 0)
			(effects
				(font
					(size 1.524 1.524)
				)
			)
		)
		(property "Value" "PCM5242RHBR"
			(at 266.7 126.2126 0)
			(effects
				(font
					(size 1.524 1.524)
				)
			)
		)
		(property "Footprint" "pcm5242:PCM5242RHBR"
			(at 266.7 127.254 0)
			(effects
				(font
					(size 1.524 1.524)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 243.84 133.35 0)
			(effects
				(font
					(size 1.524 1.524)
				)
			)
		)
		(property "Description" ""
			(at 243.84 133.35 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "5"
			(uuid "cd022cad-7a17-4d6a-bc09-7d3f3ba1530b")
		)
		(pin "1"
			(uuid "67ab9131-c9f6-4501-9a8d-7a96c427d047")
		)
		(pin "3"
			(uuid "d20af6f1-4dfd-4859-b36c-8c4125cb87f6")
		)
		(pin "14"
			(uuid "a584f103-f3a6-423b-aec6-1e86c178f208")
		)
		(pin "2"
			(uuid "b55e649d-7a42-470e-9fd2-8576cd423ef3")
		)
		(pin "15"
			(uuid "c4907f60-af97-4c27-b3f7-c33a5bda8919")
		)
		(pin "12"
			(uuid "ff0bcba5-410c-452c-b7f6-dc69477cbbd9")
		)
		(pin "4"
			(uuid "6b23f5e7-37c6-429a-b04d-f7af9d412a27")
		)
		(pin "8"
			(uuid "9b6813a3-5603-4bca-86c5-956a1bb78402")
		)
		(pin "9"
			(uuid "5b4982ef-3bc9-402f-bf4e-360420795b66")
		)
		(pin "7"
			(uuid "9fcd5f7a-1112-4dc0-8b5d-6b910dab78df")
		)
		(pin "10"
			(uuid "579a1fa5-549b-465d-8af3-eb342d6ce722")
		)
		(pin "11"
			(uuid "8734d7a1-e2d2-44ca-9069-5fda0b34d035")
		)
		(pin "6"
			(uuid "ea601475-8667-4df5-b5c8-67fbd1216453")
		)
		(pin "13"
			(uuid "562eb243-e3f3-4958-b92b-03b28a976a82")
		)
		(pin "18"
			(uuid "7e3b3446-8692-496c-acca-30c73b9e0f14")
		)
		(pin "16"
			(uuid "20b43e6c-b9e0-4540-8df2-8997d1362d15")
		)
		(pin "29"
			(uuid "c1ddb1bf-7fdc-4b4d-9ee0-7518f2e9e0f2")
		)
		(pin "28"
			(uuid "207540ba-a5f3-4b73-bbb7-1a6c52cb4301")
		)
		(pin "27"
			(uuid "ea3fe735-29dd-4e6f-8b62-5098e92fd689")
		)
		(pin "23"
			(uuid "db20ba08-676a-4c6f-a627-531c9ac3d60b")
		)
		(pin "30"
			(uuid "f1a19f5a-fb39-4cb7-b53c-5c13b3721c28")
		)
		(pin "25"
			(uuid "848a8952-5c8b-4f96-b4fc-14fe2d63b2e0")
		)
		(pin "32"
			(uuid "f5495840-a95d-400b-b4e5-fb05e7465e92")
		)
		(pin "26"
			(uuid "b3d4b3f4-7e51-4b31-8039-83ee162c4833")
		)
		(pin "33"
			(uuid "5f9fc292-09b2-4c24-9a84-cf93d32bf165")
		)
		(pin "31"
			(uuid "844ab6ab-ce4f-411d-bda2-2d254d063ee5")
		)
		(pin "24"
			(uuid "7b2d10ab-871c-4023-85d7-8fa679c9ef75")
		)
		(pin "22"
			(uuid "7a3a8f1a-ca17-480f-b672-a763df1c4d3f")
		)
		(pin "21"
			(uuid "03239bb8-a937-4c04-ac60-042bfa0da39a")
		)
		(pin "20"
			(uuid "21435576-76c3-415d-9ab9-4808f9d24588")
		)
		(pin "19"
			(uuid "de5be85f-2ea2-4518-b1d3-46c76a72f123")
		)
		(pin "17"
			(uuid "0a3e97b2-5899-4705-b3cd-596c8daf9799")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "U6")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 85.09 189.23 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8db594")
		(property "Reference" "R10"
			(at 90.3478 189.23 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "100K"
			(at 88.0364 189.23 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 86.868 189.23 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 85.09 189.23 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 85.09 189.23 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "7193e05c-82e2-4d61-ae75-207583c6c70b")
		)
		(pin "1"
			(uuid "eb24fdbd-5faf-428e-90d1-f5a3c289a49b")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R10")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 327.66 125.73 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8dd5e2")
		(property "Reference" "R21"
			(at 327.66 120.4722 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "100R"
			(at 327.66 122.7836 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 327.66 123.952 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 327.66 125.73 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 327.66 125.73 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "0fbcc16c-1343-4828-b11b-354294fcb53f")
		)
		(pin "1"
			(uuid "b1fa0d47-e87d-478f-9448-723054edcafc")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R21")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 327.66 130.81 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8de23e")
		(property "Reference" "R22"
			(at 327.66 125.5522 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "100R"
			(at 327.66 127.8636 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 327.66 129.032 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 327.66 130.81 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 327.66 130.81 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "3e7703b9-c219-4c03-825e-4ed37428cf4e")
		)
		(pin "2"
			(uuid "d4e2b8d3-dbd0-4c00-98b3-5331ae45baf0")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R22")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 96.52 189.23 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f8e0d3c")
		(property "Reference" "R11"
			(at 101.7778 189.23 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "100K"
			(at 99.4664 189.23 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 98.298 189.23 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 96.52 189.23 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 96.52 189.23 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "f3d432fe-ea61-4300-b609-27b3576a3a54")
		)
		(pin "2"
			(uuid "c1b1849d-0b58-4b37-ae7d-0dd69b77266f")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R11")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 76.2 190.5 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f900d33")
		(property "Reference" "R8"
			(at 81.4578 190.5 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "100K"
			(at 79.1464 190.5 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 77.978 190.5 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 76.2 190.5 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 76.2 190.5 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "b7cc9366-a5a6-49d2-b78b-577a9564c29a")
		)
		(pin "1"
			(uuid "7ee4a7d9-0bdb-4662-af30-4ed7a0e40d9e")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R8")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 104.14 190.5 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9010a8")
		(property "Reference" "R13"
			(at 109.3978 190.5 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "100K"
			(at 107.0864 190.5 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 105.918 190.5 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 104.14 190.5 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 104.14 190.5 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "cafd8d24-86ab-4471-9f5a-5e62dffa271e")
		)
		(pin "2"
			(uuid "1679e8f9-fbbb-4105-b12d-29eeda92c43d")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R13")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 62.23 106.68 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f905cb0")
		(property "Reference" "R3"
			(at 62.23 101.4222 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "100R"
			(at 62.23 103.7336 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 62.23 104.902 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 62.23 106.68 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 62.23 106.68 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "0d91ef95-4961-4dac-810b-b2162a48ff15")
		)
		(pin "2"
			(uuid "7b51d62b-a6de-4cda-8d72-aeca6c7a8981")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R3")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 72.39 172.72 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f91ca6a")
		(property "Reference" "R4"
			(at 74.168 171.5516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100R"
			(at 74.168 173.863 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 70.612 172.72 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 72.39 172.72 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 72.39 172.72 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "b3761f8c-e003-45b4-af1a-281c36442ffb")
		)
		(pin "2"
			(uuid "06277203-18b7-4853-98fb-1a288d72a187")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R4")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 82.55 172.72 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f91f9a5")
		(property "Reference" "R9"
			(at 84.328 171.5516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100R"
			(at 84.328 173.863 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 80.772 172.72 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 82.55 172.72 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 82.55 172.72 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "dc13dd0c-f0ef-4cad-80a8-b8a5d48cd5cf")
		)
		(pin "2"
			(uuid "56057c28-fe00-442d-9715-afef27e9255e")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R9")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 99.06 172.72 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f92058f")
		(property "Reference" "R12"
			(at 100.838 171.5516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100R"
			(at 100.838 173.863 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 97.282 172.72 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 99.06 172.72 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 99.06 172.72 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "ce46f18e-9770-46bb-9573-b92117dc1292")
		)
		(pin "2"
			(uuid "ebdcdab2-8021-470f-8373-96768ce68f3e")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R12")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 121.92 172.72 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f920ef8")
		(property "Reference" "R14"
			(at 123.698 171.5516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100R"
			(at 123.698 173.863 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 120.142 172.72 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 121.92 172.72 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 121.92 172.72 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "e938d605-d025-4426-bc1e-61398e4933be")
		)
		(pin "2"
			(uuid "28c7329b-0020-4e27-a9c3-7070ae296b73")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R14")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 173.99 121.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f928bcf")
		(property "Reference" "C15"
			(at 175.1584 124.841 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nf25V"
			(at 172.847 124.841 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 170.18 122.8852 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 173.99 121.92 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 173.99 121.92 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "ef69528e-e51f-4bc8-8f00-7823280ef753")
		)
		(pin "2"
			(uuid "d00a7796-0b05-4d47-b84b-88242d95036c")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C15")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 173.99 115.57 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f929a6d")
		(property "Reference" "C14"
			(at 175.1584 118.491 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "1uf16v"
			(at 172.847 118.491 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0603_1608Metric"
			(at 170.18 116.5352 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 173.99 115.57 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 173.99 115.57 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "2f4e47f3-9001-4f76-9f85-6ac72b0d1e39")
		)
		(pin "2"
			(uuid "584c9704-5ea7-4123-a114-bc6feab4bbea")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C14")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Connector_Generic:Conn_02x10_Odd_Even")
		(at 38.1 146.05 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f93e5a0")
		(property "Reference" "J2"
			(at 39.37 130.3782 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "Conn_02x10_Odd_Even"
			(at 39.37 132.6896 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Connector_PinHeader_2.54mm:PinHeader_2x10_P2.54mm_Vertical"
			(at 38.1 146.05 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 38.1 146.05 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 38.1 146.05 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "4"
			(uuid "597c606d-0bd4-449b-96ee-0998b8906f99")
		)
		(pin "19"
			(uuid "be9d2b52-50c8-4f70-889e-616a0349b7c8")
		)
		(pin "18"
			(uuid "8ca69045-8550-4d58-a2a7-ed88090aa707")
		)
		(pin "11"
			(uuid "35acd548-85fb-4cd7-bcdc-d3bad2d52866")
		)
		(pin "7"
			(uuid "ae85c127-5db1-4aa8-aa62-c69cd7fe0b10")
		)
		(pin "3"
			(uuid "f888aa9a-740c-4c48-b913-731763914873")
		)
		(pin "20"
			(uuid "389520a8-8c0e-40d5-95d1-31961ff92e16")
		)
		(pin "13"
			(uuid "e9423709-ff04-4216-af0d-243639e59b27")
		)
		(pin "2"
			(uuid "69ef4d71-a92d-47a9-ae73-f736d09fa2ec")
		)
		(pin "17"
			(uuid "30a02442-491e-4153-93f0-a7c595357093")
		)
		(pin "9"
			(uuid "5169c02c-7af4-4098-ac84-729ef6fca1b4")
		)
		(pin "1"
			(uuid "e2e79099-bb71-44fb-a926-d1b27783b096")
		)
		(pin "15"
			(uuid "06a82893-6fe9-4a44-9b01-732e21254d9b")
		)
		(pin "5"
			(uuid "afb48e90-c95d-4bb3-8034-13fe0a86e1f1")
		)
		(pin "6"
			(uuid "77590d39-31b9-4909-b124-41691c7b5eb3")
		)
		(pin "8"
			(uuid "11d4fdcf-8792-4384-8b13-c502269f4026")
		)
		(pin "10"
			(uuid "1b12027c-c7e2-4d3a-a4bf-1c6e1ed333e5")
		)
		(pin "12"
			(uuid "7e99de4f-3ec1-4795-a891-2edc20979b3b")
		)
		(pin "14"
			(uuid "c0de010c-0ac2-4803-b474-5430cfb4e2c0")
		)
		(pin "16"
			(uuid "1c2fd960-1847-4e13-b98e-b2bb1b6ebbc1")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "J2")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 30.48 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f957322")
		(property "Reference" "#PWR0104"
			(at 30.48 171.45 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 30.607 169.4942 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 30.48 165.1 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 30.48 165.1 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 30.48 165.1 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "b8bdf3a3-2bb2-4efa-b26a-169cf69417f7")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0104")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 100.33 194.31 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f95e3a9")
		(property "Reference" "#PWR0105"
			(at 100.33 200.66 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 100.457 198.7042 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 100.33 194.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 100.33 194.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 100.33 194.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "80920848-7115-4549-af8c-a96d219d02fa")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0105")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 218.44 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f96b3b2")
		(property "Reference" "R18"
			(at 220.218 179.1716 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "470R"
			(at 220.218 181.483 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 216.662 180.34 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 218.44 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 218.44 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "15ae140c-6cac-46aa-ad7e-4272079e6f6d")
		)
		(pin "2"
			(uuid "d6ff4563-1e45-4a29-939b-48fe6ec997c4")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R18")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 218.44 191.77 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f96c0ac")
		(property "Reference" "C20"
			(at 221.361 190.6016 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "2,2nf50v"
			(at 221.361 192.913 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 219.4052 195.58 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 218.44 191.77 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 218.44 191.77 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "04912565-0e5f-4904-9561-4006a4ad9050")
		)
		(pin "1"
			(uuid "ebfd99e9-dad0-44a2-801c-38b47e7efd38")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C20")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 212.09 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9a71b1")
		(property "Reference" "R17"
			(at 213.868 179.1716 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "470R"
			(at 213.868 181.483 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 210.312 180.34 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 212.09 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 212.09 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "69a62e04-0474-4120-b784-f88951e00b94")
		)
		(pin "2"
			(uuid "08be40d9-e316-4a74-b2f1-04e9674a4f12")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R17")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 205.74 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9aacf9")
		(property "Reference" "R16"
			(at 207.518 179.1716 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "470R"
			(at 207.518 181.483 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 203.962 180.34 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 205.74 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 205.74 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "797d0989-2411-43d2-97bd-7ce41b3c760c")
		)
		(pin "2"
			(uuid "acb1a732-5e80-4804-bdce-7834de756f8c")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R16")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 199.39 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9ab452")
		(property "Reference" "R15"
			(at 201.168 179.1716 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "470R"
			(at 201.168 181.483 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 197.612 180.34 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 199.39 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 199.39 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "03778f15-49d4-41bc-bb23-4749a43e5361")
		)
		(pin "2"
			(uuid "bde642f9-85bc-404c-a844-65b49d9774e8")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R15")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 212.09 191.77 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9ab9b8")
		(property "Reference" "C16"
			(at 215.011 190.6016 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "2,2nf50v"
			(at 215.011 192.913 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 213.0552 195.58 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 212.09 191.77 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 212.09 191.77 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "dc2033a7-6842-453b-b698-cfefec6b495b")
		)
		(pin "2"
			(uuid "13c46922-e30d-477e-8438-201402c37a20")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C16")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 205.74 191.77 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9b166e")
		(property "Reference" "C11"
			(at 208.661 190.6016 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "2,2nf50v"
			(at 208.661 192.913 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 206.7052 195.58 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 205.74 191.77 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 205.74 191.77 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "5fbfb3ad-4573-4770-b3c8-78b738f48c9f")
		)
		(pin "1"
			(uuid "c46acbac-c0a5-43a5-9946-155bb817e1a5")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C11")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 199.39 191.77 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9b1c78")
		(property "Reference" "C10"
			(at 202.311 190.6016 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "2,2nf50v"
			(at 202.311 192.913 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 200.3552 195.58 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 199.39 191.77 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 199.39 191.77 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "2116c33b-ae26-4526-bc8c-9faa7ee77fcc")
		)
		(pin "2"
			(uuid "22fb42d4-aa9e-4b4a-ac8a-9a2fa1b2e052")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C10")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 168.91 105.41 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9d38ed")
		(property "Reference" "C12"
			(at 171.831 104.2416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nf25v"
			(at 171.831 106.553 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 169.8752 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 168.91 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 168.91 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "1fe70a96-aa72-43e6-877b-c8a8f382f570")
		)
		(pin "2"
			(uuid "c2eb3f56-9e9a-4fe2-9e22-5591ac2f7c6c")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C12")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 82.55 181.61 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9d72cc")
		(property "Reference" "C2"
			(at 85.471 180.4416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 85.471 182.753 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 83.5152 185.42 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 82.55 181.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 82.55 181.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "37545d4c-658d-4e7c-8fe4-ac92ce868016")
		)
		(pin "2"
			(uuid "99e49f28-2a7d-4f65-a14c-5736d62ece68")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C2")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 99.06 181.61 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9d7682")
		(property "Reference" "C3"
			(at 101.981 180.4416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 101.981 182.753 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 100.0252 185.42 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 99.06 181.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 99.06 181.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "c97d4ce5-4f90-40fa-a13e-a238d83daed5")
		)
		(pin "2"
			(uuid "98b33f59-1276-45b7-b351-d00d3e493f04")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C3")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 121.92 181.61 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9d7c0d")
		(property "Reference" "C6"
			(at 124.841 180.4416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 124.841 182.753 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 122.8852 185.42 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 121.92 181.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 121.92 181.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "b4324298-b1dd-434c-9823-82042500242a")
		)
		(pin "2"
			(uuid "01b63bf3-2402-483d-a32c-ee4db2dd23f3")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C6")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 62.23 38.1 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9ea02e")
		(property "Reference" "C30"
			(at 59.309 39.2684 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nf25v"
			(at 59.309 36.957 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 61.2648 34.29 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 62.23 38.1 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 62.23 38.1 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "b74433f7-b964-47a3-a03f-b2cc9f7c7cbc")
		)
		(pin "2"
			(uuid "b5a81b53-df86-481e-9de2-eb4059fb04e5")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C30")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 82.55 34.29 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9ec8cc")
		(property "Reference" "R6"
			(at 82.55 29.0322 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "3K8"
			(at 82.55 31.3436 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 82.55 32.512 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 82.55 34.29 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 82.55 34.29 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "e43c648b-9bd9-4140-b2d1-f8cde50d9e27")
		)
		(pin "1"
			(uuid "6fc9394c-cc8a-4238-8b0a-879e3e78f095")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R6")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 82.55 26.67 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9ed958")
		(property "Reference" "R5"
			(at 82.55 21.4122 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "3K8"
			(at 82.55 23.7236 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 82.55 24.892 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 82.55 26.67 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 82.55 26.67 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "6c3c7987-70b0-4c90-b1b9-feadd26e99c5")
		)
		(pin "1"
			(uuid "4942c8dc-dd3b-487c-9971-75f1bbded068")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R5")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Connector:AudioJack2_Ground_Switch")
		(at 85.09 210.82 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9f1fd0")
		(property "Reference" "J3"
			(at 85.9028 200.025 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "AudioJack2_Ground_Switch"
			(at 85.9028 202.3364 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "zynthiandac:conn_audio5"
			(at 85.09 205.74 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 85.09 205.74 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 85.09 210.82 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "SN"
			(uuid "e2208677-9a6f-44b1-94fd-ef958d91fe37")
		)
		(pin "S"
			(uuid "e06fdc48-5378-4945-a12b-08361663bdc5")
		)
		(pin "TN"
			(uuid "88fb9712-92bc-4959-a0fd-7d5da5873083")
		)
		(pin "G"
			(uuid "b89e31ad-115d-4486-a592-7e18eeeba146")
		)
		(pin "T"
			(uuid "bac33d99-f904-40ee-a388-365200889170")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "J3")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "zynthiandac-rescue:TLV71333PDBV-Regulator_Linear")
		(at 163.83 67.31 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9f6f73")
		(property "Reference" "U5"
			(at 163.83 58.6232 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "ncp163"
			(at 163.83 60.9346 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Package_TO_SOT_SMD:SOT-23-5"
			(at 163.83 59.055 0)
			(effects
				(font
					(size 1.27 1.27)
					(italic yes)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "https://www.onsemi.com/pub/Collateral/NCP163-D.PDF"
			(at 163.83 66.04 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 163.83 67.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "98b376fd-f7b8-4f18-b32e-4f5a5d27a5db")
		)
		(pin "4"
			(uuid "3148471b-4f64-4652-ba70-b8c45d1be429")
		)
		(pin "3"
			(uuid "f02cb7de-676c-40f9-b732-e6c9d4f7d156")
		)
		(pin "2"
			(uuid "b98a8407-d566-4496-9f5d-5759a6a651ec")
		)
		(pin "5"
			(uuid "6d2b10da-8ff1-49e5-841f-53b54ab4d0ee")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "U5")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 168.91 17.78 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005f9fac6d")
		(property "Reference" "R19"
			(at 170.0784 19.558 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100R"
			(at 167.767 19.558 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0603_1608Metric"
			(at 168.91 16.002 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 168.91 17.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 168.91 17.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "380a48a4-8bf9-49e7-a023-0cfb7cd20666")
		)
		(pin "2"
			(uuid "e96efa03-af1b-44d5-aaef-edb38ec08ea1")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R19")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 144.78 71.12 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa1450b")
		(property "Reference" "C8"
			(at 147.701 69.9516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 147.701 72.263 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 145.7452 74.93 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 144.78 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 144.78 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "8c96071b-ed8b-446a-a152-56fcbc096bbc")
		)
		(pin "2"
			(uuid "d98c5075-92f9-421b-87f4-5e2796148ccd")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C8")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 119.38 71.12 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa14af9")
		(property "Reference" "C5"
			(at 122.301 69.9516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 122.301 72.263 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 120.3452 74.93 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 119.38 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 119.38 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "8548f1a7-9540-4ecf-aac2-be3af6acd05f")
		)
		(pin "1"
			(uuid "497f6e3b-2955-4345-b5b9-d3f55632fe54")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C5")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 82.55 49.53 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa1726c")
		(property "Reference" "R7"
			(at 82.55 44.2722 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "3K8"
			(at 82.55 46.5836 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 82.55 47.752 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 82.55 49.53 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 82.55 49.53 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "6ebc697f-0dc0-4980-9277-e4912e04d073")
		)
		(pin "2"
			(uuid "6c4b4384-2644-4597-8606-3f9672635795")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R7")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 157.48 232.41 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa40e46")
		(property "Reference" "#PWR0106"
			(at 157.48 238.76 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 157.607 236.8042 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 157.48 232.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 157.48 232.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 157.48 232.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "1a0dd740-2265-4f98-80d3-ef2ca8449a7a")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0106")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:PWR_FLAG")
		(at 99.06 66.04 90)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa5d20d")
		(property "Reference" "#FLG0101"
			(at 97.155 66.04 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "PWR_FLAG"
			(at 95.8342 66.04 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" ""
			(at 99.06 66.04 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 99.06 66.04 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 99.06 66.04 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "525dec16-3211-417a-afbc-3f4917b101c7")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#FLG0101")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "zynthiandac-rescue:TLV71333PDBV-Regulator_Linear")
		(at 135.89 67.31 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa6fd02")
		(property "Reference" "U4"
			(at 135.89 58.6232 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "ncp163"
			(at 135.89 60.9346 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Package_TO_SOT_SMD:SOT-23-5"
			(at 135.89 59.055 0)
			(effects
				(font
					(size 1.27 1.27)
					(italic yes)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "https://www.onsemi.com/pub/Collateral/NCP163-D.PDF"
			(at 135.89 66.04 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 135.89 67.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "d09d2535-cfa1-414e-a53d-b5a7798d2423")
		)
		(pin "4"
			(uuid "b6b424cf-7c1f-4f41-bb27-054efe4d447f")
		)
		(pin "3"
			(uuid "6b71e17c-489c-4cc4-8992-75f13998a8f4")
		)
		(pin "2"
			(uuid "14c198a1-c7b7-4a1d-a7b6-2fb6e0f3733e")
		)
		(pin "5"
			(uuid "1a0f0b3b-1fa4-4d5b-9c79-b4e02ba38003")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "U4")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 226.06 134.62 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa80c7c")
		(property "Reference" "C31"
			(at 223.139 135.7884 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nf25v"
			(at 223.139 133.477 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 225.0948 130.81 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 226.06 134.62 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 226.06 134.62 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "870e3cd8-1071-42ff-a803-c5810bdc5223")
		)
		(pin "2"
			(uuid "0f883013-a7d0-44d9-ae45-0b00fe5ce746")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C31")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 85.09 218.44 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa8753e")
		(property "Reference" "#PWR0107"
			(at 85.09 224.79 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 85.217 222.8342 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 85.09 218.44 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 85.09 218.44 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 85.09 218.44 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "3f034d4a-0ea9-4816-ac5e-04eb3b8abc21")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0107")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Connector:AudioJack2_Ground")
		(at 157.48 227.33 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa89642")
		(property "Reference" "J4"
			(at 158.2928 219.075 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "AudioJack2_Ground"
			(at 158.2928 221.3864 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "zynthiandac:conn_audio3"
			(at 157.48 227.33 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 157.48 227.33 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 157.48 227.33 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "S"
			(uuid "bcfdd8db-f03d-4984-aedf-f43044348acf")
		)
		(pin "T"
			(uuid "95e143e0-11fa-4672-8754-a7fec824a233")
		)
		(pin "G"
			(uuid "d776c1c6-f727-4ee6-b003-650cf2bf83ed")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "J4")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 195.58 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fa8c884")
		(property "Reference" "#PWR0113"
			(at 208.28 201.93 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 208.407 199.9742 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 208.28 195.58 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 208.28 195.58 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 208.28 195.58 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "170c8c16-fea4-4d4b-aaac-f16bc5945e91")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0113")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "conn_02x20:Conn_2x20")
		(at 139.7 41.91 90)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005faa94ad")
		(property "Reference" "J6"
			(at 114.3 40.64 0)
			(effects
				(font
					(size 0.508 0.508)
				)
				(hide yes)
			)
		)
		(property "Value" "Conn_2x20"
			(at 167.132 40.64 90)
			(effects
				(font
					(size 0.9906 0.9906)
				)
				(justify right)
			)
		)
		(property "Footprint" "Connector_PinSocket_2.54mm:PinSocket_2x20_P2.54mm_Vertical"
			(at 139.7 41.91 0)
			(effects
				(font
					(size 0.508 0.508)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 139.7 41.91 0)
			(effects
				(font
					(size 0.508 0.508)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 139.7 41.91 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "15"
			(uuid "ce9a6ac5-8233-4994-9f54-d02bf20baacb")
		)
		(pin "23"
			(uuid "678faefd-69c7-4d2c-863b-a75ebc83d026")
		)
		(pin "37"
			(uuid "232933fa-b9ee-44a7-ab19-9872bc9543ba")
		)
		(pin "27"
			(uuid "f59b25fd-9874-47c6-abb6-6e26bc0c1191")
		)
		(pin "4"
			(uuid "e647b3f7-29be-44ae-83f3-4c5a928f3d5d")
		)
		(pin "1"
			(uuid "95610bb0-d687-479f-af52-03344dbaa167")
		)
		(pin "12"
			(uuid "b486ee75-3d2a-497c-9c6b-e19d6bbefd68")
		)
		(pin "7"
			(uuid "5cad39e4-41b7-4157-8950-73e3d5f72d38")
		)
		(pin "13"
			(uuid "310cddd3-1363-418d-a77e-fdb9cf0aadc1")
		)
		(pin "21"
			(uuid "d44d7372-6438-4a5a-99ad-a677604c8377")
		)
		(pin "9"
			(uuid "885513ef-77ea-4833-96f0-b3ec329bea97")
		)
		(pin "3"
			(uuid "bdd75382-ab52-493c-b909-3fa776f44d57")
		)
		(pin "5"
			(uuid "3f5697c6-08b0-4a45-8001-efd5343f95e5")
		)
		(pin "17"
			(uuid "b5c6df26-61a0-4d3f-b4cd-73073064b0c8")
		)
		(pin "19"
			(uuid "bc88e5c1-d56e-4a0c-9188-b64f769e3fbd")
		)
		(pin "29"
			(uuid "0118da70-7e2c-45e9-b121-b3fe94998c9c")
		)
		(pin "25"
			(uuid "2a23f6a8-3535-48f5-b2e5-a22e5cc7aa17")
		)
		(pin "31"
			(uuid "beea8c95-e633-4a11-b005-4a7156fb4439")
		)
		(pin "11"
			(uuid "a81224bc-2fc9-4895-bb54-4216780d5067")
		)
		(pin "33"
			(uuid "adf9861f-d9cc-422f-98b9-2cc85ad22d38")
		)
		(pin "35"
			(uuid "21eb9bff-2e67-4d5a-ba85-151dd1fe0267")
		)
		(pin "39"
			(uuid "38f2d100-d0d7-4617-9368-dd5c8aed97be")
		)
		(pin "2"
			(uuid "d0dccdd0-dcd5-4984-a0d6-2faf701d5716")
		)
		(pin "6"
			(uuid "211b33fe-2a80-4314-a424-877afc6a6796")
		)
		(pin "8"
			(uuid "1310bd70-ff3f-480f-b839-006d6eb060c7")
		)
		(pin "10"
			(uuid "ff644579-dd23-46a0-9ee4-1bec660e0dda")
		)
		(pin "14"
			(uuid "68cd5058-83e9-4cd9-a1d1-14e89912bba5")
		)
		(pin "16"
			(uuid "e966f281-1c0d-439c-89ae-4f9c85d92256")
		)
		(pin "18"
			(uuid "4059b26c-c69a-411a-ac35-d9e6b3027e69")
		)
		(pin "36"
			(uuid "95744412-372d-4d1f-aad9-28c88041f187")
		)
		(pin "32"
			(uuid "40032df8-de50-42ef-8209-eb0dfe0359bc")
		)
		(pin "40"
			(uuid "564468c5-7ad2-4c58-a1bf-5b63f338209d")
		)
		(pin "22"
			(uuid "b7dbdade-1e7e-49f1-b2cf-465892b7d0ed")
		)
		(pin "20"
			(uuid "a3f5f7f4-7463-42c9-aecb-978efa3c0920")
		)
		(pin "24"
			(uuid "16ebb9ff-3374-4158-89fa-fde73a535bde")
		)
		(pin "26"
			(uuid "d04b58e8-edbc-44e6-9b41-a1a48d472b62")
		)
		(pin "30"
			(uuid "a3313cbd-4ccc-4eb2-abf2-ec2b5663b36f")
		)
		(pin "38"
			(uuid "6d26b500-299a-4e1a-914f-f6ee9b5bf25f")
		)
		(pin "34"
			(uuid "be66bea6-f42f-4678-970b-aa2ade40920b")
		)
		(pin "28"
			(uuid "42512324-01d3-4ea4-b1fd-a10b97b7a399")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "J6")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 232.41 138.43 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005faa9fc7")
		(property "Reference" "#PWR03"
			(at 232.41 144.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 232.537 142.8242 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 232.41 138.43 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 232.41 138.43 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 232.41 138.43 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "0bb0fd1f-9a97-4e21-84d9-4bc8c8fc15fc")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR03")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Connector:AudioJack2_Ground")
		(at 186.69 227.33 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fabd7a2")
		(property "Reference" "J5"
			(at 187.5028 219.075 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "AudioJack2_Ground"
			(at 187.5028 221.3864 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "zynthiandac:conn_audio3"
			(at 186.69 227.33 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 186.69 227.33 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 186.69 227.33 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "G"
			(uuid "167da067-cc5a-4282-a439-d86ba4dd9901")
		)
		(pin "T"
			(uuid "5c59fe0b-fd74-4653-9458-61f1e8331d05")
		)
		(pin "S"
			(uuid "5ea23ce9-c029-4eeb-9203-e6cc62617154")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "J5")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 186.69 232.41 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fabdf8f")
		(property "Reference" "#PWR0116"
			(at 186.69 238.76 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 186.817 236.8042 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 186.69 232.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 186.69 232.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 186.69 232.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "db0e1e7d-5af7-4bae-84c5-77de6c82aa85")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0116")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Memory_EEPROM:AT24CS01-STUM")
		(at 74.93 41.91 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fac277d")
		(property "Reference" "U2"
			(at 66.548 40.7416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify right)
			)
		)
		(property "Value" "AT24CS01-STUM"
			(at 66.548 43.053 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify right)
			)
		)
		(property "Footprint" "Package_TO_SOT_SMD:SOT-23-5"
			(at 74.93 41.91 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "http://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-8815-SEEPROM-AT24CS01-02-Datasheet.pdf"
			(at 74.93 41.91 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 74.93 41.91 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "3"
			(uuid "5d22477a-30a0-4558-95f1-ebacb15f2dc5")
		)
		(pin "4"
			(uuid "0eb7e55d-90d6-4d76-80ca-935c117c730f")
		)
		(pin "2"
			(uuid "dd7f6307-1f66-4b7e-b693-20062b0ede15")
		)
		(pin "1"
			(uuid "06f44a66-a304-4d01-9d1d-b191af28c999")
		)
		(pin "5"
			(uuid "d107c913-1d28-40a3-9c3a-e45d386e7a05")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "U2")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "zynthiandac-rescue:TLV71333PDBV-Regulator_Linear")
		(at 110.49 67.31 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fad063e")
		(property "Reference" "U3"
			(at 110.49 58.6232 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "ncp163"
			(at 110.49 60.9346 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Package_TO_SOT_SMD:SOT-23-5"
			(at 110.49 59.055 0)
			(effects
				(font
					(size 1.27 1.27)
					(italic yes)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "https://www.onsemi.com/pub/Collateral/NCP163-D.PDF"
			(at 110.49 66.04 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 110.49 67.31 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "3"
			(uuid "9e38ef60-0871-460e-a7c9-c29e5b6101ab")
		)
		(pin "4"
			(uuid "29a6002c-f988-4dc3-a6e3-d1f7ede9c3e0")
		)
		(pin "2"
			(uuid "a6986db2-b27f-4f5a-a75a-781da68ece91")
		)
		(pin "5"
			(uuid "443fb59b-e22b-427f-aae5-2b9470c5107b")
		)
		(pin "1"
			(uuid "493eda46-812c-4b92-b4af-24c6d018b446")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "U3")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 237.49 170.18 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fad5082")
		(property "Reference" "C33"
			(at 234.569 171.3484 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "1uf16v"
			(at 234.569 169.037 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0603_1608Metric"
			(at 236.5248 166.37 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 237.49 170.18 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 237.49 170.18 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "7fc1ee75-38b3-410c-a061-5ff55bb55429")
		)
		(pin "2"
			(uuid "cf9f18a4-c805-44a8-9aad-1cc3d3dafc31")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C33")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 175.26 105.41 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fae13d8")
		(property "Reference" "C17"
			(at 178.181 104.2416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 178.181 106.553 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 176.2252 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 175.26 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 175.26 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "196bdd74-2c85-4766-9c4c-1e52bf64701b")
		)
		(pin "1"
			(uuid "210e3eb1-430f-44c3-bb1c-46c813d53340")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C17")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:PWR_FLAG")
		(at 106.68 59.69 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005faf1710")
		(property "Reference" "#FLG0102"
			(at 106.68 57.785 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "PWR_FLAG"
			(at 106.68 55.2958 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 106.68 59.69 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 106.68 59.69 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 106.68 59.69 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "bbf85da3-fce1-49ee-9108-a6f2463d92e9")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#FLG0102")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:PWR_FLAG")
		(at 168.91 116.84 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fb29fe9")
		(property "Reference" "#FLG0103"
			(at 170.815 116.84 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "PWR_FLAG"
			(at 172.1612 116.84 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" ""
			(at 168.91 116.84 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 168.91 116.84 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 168.91 116.84 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "3bdde4fc-6d11-470c-8f9e-358536f70414")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#FLG0103")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 186.69 105.41 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fb3aa47")
		(property "Reference" "C34"
			(at 189.611 104.2416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "1uf16v"
			(at 189.611 106.553 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0603_1608Metric"
			(at 187.6552 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 186.69 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 186.69 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "ba152461-535b-40c5-bf84-ab3939a12f0f")
		)
		(pin "1"
			(uuid "fc50bcfd-26e7-4de4-8b4c-53487bd02c78")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C34")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 193.04 105.41 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fb3affc")
		(property "Reference" "C35"
			(at 195.961 104.2416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "1uf16v"
			(at 195.961 106.553 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0603_1608Metric"
			(at 194.0052 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 193.04 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 193.04 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "2140d890-b7d4-49ad-ae91-46201155c5b2")
		)
		(pin "2"
			(uuid "b0c17c68-e7f2-4398-8dba-b310f6f3ae5b")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C35")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 91.44 49.53 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fb44114")
		(property "Reference" "R28"
			(at 91.44 44.2722 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "3K8"
			(at 91.44 46.5836 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 91.44 47.752 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 91.44 49.53 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 91.44 49.53 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "403784c6-514d-4b1f-8f33-dd66c57359bf")
		)
		(pin "2"
			(uuid "921b4606-04f9-47b4-a89a-59850d67fa8b")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R28")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:LED")
		(at 306.07 166.37 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fb5b263")
		(property "Reference" "D2"
			(at 306.2478 171.8564 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "LED"
			(at 306.2478 169.545 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "zynthiandac:led_0806"
			(at 306.07 166.37 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 306.07 166.37 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 306.07 166.37 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "e2a019f2-d472-4724-a432-d46ca4680162")
		)
		(pin "2"
			(uuid "40f0b361-fccb-43a7-ae28-e910418f51d1")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "D2")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 311.15 162.56 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fb5b269")
		(property "Reference" "R20"
			(at 305.8922 162.56 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "10k"
			(at 308.2036 162.56 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 309.372 162.56 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 311.15 162.56 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 311.15 162.56 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "5d859de9-d96d-45ea-80ee-f2d589c92008")
		)
		(pin "1"
			(uuid "ca365336-48c3-4fc6-995a-02162db288ff")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R20")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 76.2 49.53 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fba5fff")
		(property "Reference" "#PWR0108"
			(at 76.2 55.88 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 76.327 53.9242 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 76.2 49.53 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 76.2 49.53 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 76.2 49.53 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "6283b6f7-255d-4043-8b66-70518fb98872")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0108")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 180.34 105.41 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fc59c6c")
		(property "Reference" "C19"
			(at 183.261 104.2416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nf16v"
			(at 183.261 106.553 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 181.3052 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 180.34 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 180.34 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "db0daaf3-9608-4f6f-8dbd-071cc7662866")
		)
		(pin "2"
			(uuid "a8ccb048-0c3f-40be-91f5-e7b7fc39e898")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C19")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 199.39 105.41 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fc5a22e")
		(property "Reference" "C21"
			(at 202.311 104.2416 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nf25v"
			(at 202.311 106.553 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 200.3552 109.22 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 199.39 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 199.39 105.41 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "c541ad81-3031-4cfb-9498-88ee48b7dc79")
		)
		(pin "1"
			(uuid "b5f02f7d-ab5e-4e16-85db-e1ea6c3f38c2")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C21")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 135.89 76.2 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fd14bc3")
		(property "Reference" "#PWR0109"
			(at 135.89 82.55 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 136.017 80.5942 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 135.89 76.2 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 135.89 76.2 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 135.89 76.2 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "eec2d035-2244-4667-bb59-6023810f990a")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0109")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 173.99 71.12 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fda9396")
		(property "Reference" "C13"
			(at 176.911 69.9516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 176.911 72.263 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 174.9552 74.93 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 173.99 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 173.99 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "1bf2f287-835d-406a-8c01-6fd47c028669")
		)
		(pin "2"
			(uuid "5db82331-d47f-467d-80e2-ebd8b4f474a3")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C13")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 156.21 71.12 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fdee399")
		(property "Reference" "C9"
			(at 159.131 69.9516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 159.131 72.263 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 157.1752 74.93 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 156.21 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 156.21 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "a940492a-8f3a-4406-8b95-0511bba6f0d7")
		)
		(pin "2"
			(uuid "9db06ef9-7d28-4874-9c85-12a3d0c5239f")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C9")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 128.27 71.12 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fdeeaed")
		(property "Reference" "C7"
			(at 131.191 69.9516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 131.191 72.263 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 129.2352 74.93 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 128.27 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 128.27 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "48e2f8bf-e4a6-4591-a51c-082c5ad4753f")
		)
		(pin "1"
			(uuid "d6c4145c-84ba-46c0-90dd-68dd44842b4b")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C7")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 102.87 71.12 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fdef2c3")
		(property "Reference" "C4"
			(at 105.791 69.9516 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "10uf16v"
			(at 105.791 72.263 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric"
			(at 103.8352 74.93 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 102.87 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 102.87 71.12 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "90b5965b-b952-40b6-8853-bdd0c6c21ac9")
		)
		(pin "2"
			(uuid "db3e4814-5d08-474c-bc0a-e45a93526639")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C4")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 232.41 170.18 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fe1d4f0")
		(property "Reference" "C23"
			(at 235.331 169.0116 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nf16v"
			(at 235.331 171.323 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 233.3752 173.99 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 232.41 170.18 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 232.41 170.18 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "ed44ec2f-d1b2-41f8-94ec-3c3445403b3c")
		)
		(pin "1"
			(uuid "e6c7a366-75c9-4f1c-bb6b-dbafd09d7efe")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C23")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 226.06 144.78 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fe1e65d")
		(property "Reference" "C22"
			(at 223.139 145.9484 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "1uf16V"
			(at 223.139 143.637 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0603_1608Metric"
			(at 225.0948 140.97 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 226.06 144.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 226.06 144.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "7d7c1cf8-d72e-40db-b47b-166191905017")
		)
		(pin "2"
			(uuid "3cc654ff-831c-4aa1-8745-7b4c1e911254")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C22")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 222.25 148.59 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fe62d01")
		(property "Reference" "#PWR0110"
			(at 222.25 154.94 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 222.377 152.9842 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 222.25 148.59 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 222.25 148.59 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 222.25 148.59 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "09e21025-48b8-490e-a00c-46ecbd1b4afb")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0110")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 234.95 173.99 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fe63754")
		(property "Reference" "#PWR0111"
			(at 234.95 180.34 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 235.077 178.3842 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 234.95 173.99 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 234.95 173.99 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 234.95 173.99 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "fd84dc35-0edb-4602-b290-82cf4c1507e1")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0111")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 323.85 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fe74a0f")
		(property "Reference" "R24"
			(at 318.5922 137.16 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "10k"
			(at 320.9036 137.16 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 322.072 137.16 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 323.85 137.16 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 323.85 137.16 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "77792218-0f9d-49d6-ab02-15304b7493fe")
		)
		(pin "2"
			(uuid "72962b52-9a33-4285-93d1-d9af7c6e95ad")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R24")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:R")
		(at 318.77 139.7 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fe76d0a")
		(property "Reference" "R23"
			(at 313.5122 139.7 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Value" "10k"
			(at 315.8236 139.7 90)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" "Resistor_SMD:R_0402_1005Metric"
			(at 316.992 139.7 90)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 318.77 139.7 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 318.77 139.7 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "b0a409c0-3354-4288-a936-d14b8ff7633c")
		)
		(pin "1"
			(uuid "2d0fbae2-36b0-4893-8fc4-d4d4bcc4ce02")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "R23")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 379.73 128.27 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005fe78369")
		(property "Reference" "C28"
			(at 382.651 127.1016 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nf25v"
			(at 382.651 129.413 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 380.6952 132.08 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 379.73 128.27 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 379.73 128.27 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "c3c7c39e-e34f-41ec-8ee2-51d5fd19564f")
		)
		(pin "2"
			(uuid "b2d486d6-121d-4e6d-9da5-9937e8bdeaf6")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C28")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 240.03 148.59 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-00005ffbef88")
		(property "Reference" "C26"
			(at 237.109 149.7584 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "1uf 16v"
			(at 237.109 147.447 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0603_1608Metric"
			(at 239.0648 144.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 240.03 148.59 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 240.03 148.59 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "5fad6a73-80e2-4e21-a550-9671e42fb01a")
		)
		(pin "2"
			(uuid "121e38b0-c050-4384-a1fa-c4fcf41b1a4a")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C26")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 237.49 153.67 90)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-000060006c3f")
		(property "Reference" "C24"
			(at 236.3216 150.749 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "1uf 16v"
			(at 238.633 150.749 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0603_1608Metric"
			(at 241.3 152.7048 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 237.49 153.67 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 237.49 153.67 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "49741b32-93d1-4e63-88cc-bcb1213fb549")
		)
		(pin "2"
			(uuid "5d7cbb01-83e1-4c42-9c97-a3136809c308")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C24")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 219.71 134.62 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-000060070522")
		(property "Reference" "C25"
			(at 216.789 135.7884 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "1uf16v"
			(at 216.789 133.477 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0603_1608Metric"
			(at 218.7448 130.81 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 219.71 134.62 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 219.71 134.62 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "f32c59c2-3744-4199-ade3-c9103ae66e41")
		)
		(pin "1"
			(uuid "ee8f8282-a3c0-4844-a019-815946bd92c6")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C25")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 214.63 144.78 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-0000600b948e")
		(property "Reference" "C18"
			(at 211.709 145.9484 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Value" "100nF25V"
			(at 211.709 143.637 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(justify left)
			)
		)
		(property "Footprint" "Capacitor_SMD:C_0402_1005Metric"
			(at 213.6648 140.97 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" "~"
			(at 214.63 144.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 214.63 144.78 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "2"
			(uuid "3144e067-21b5-4451-b7c0-5d9b7189e8f2")
		)
		(pin "1"
			(uuid "3a341a81-252e-48bf-afcc-c5cc1caafc0d")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "C18")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 292.1 132.08 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-0000601549cf")
		(property "Reference" "#PWR0115"
			(at 292.1 138.43 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 292.227 136.4742 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 292.1 132.08 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 292.1 132.08 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 292.1 132.08 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "97ce0b7f-1ba4-4690-a31f-0298e22d06f4")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR0115")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 165.1 48.26 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-0000601b3a11")
		(property "Reference" "#PWR02"
			(at 165.1 54.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 165.227 52.6542 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 165.1 48.26 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 165.1 48.26 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 165.1 48.26 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "ea76e6cb-2487-4a1b-b171-5a232b68e3b2")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR02")
					(unit 1)
				)
			)
		)
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 48.26 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "00000000-0000-0000-0000-0000601dafec")
		(property "Reference" "#PWR01"
			(at 147.32 54.61 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Value" "GND"
			(at 147.447 52.6542 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(property "Footprint" ""
			(at 147.32 48.26 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Datasheet" ""
			(at 147.32 48.26 0)
			(effects
				(font
					(size 1.27 1.27)
				)
				(hide yes)
			)
		)
		(property "Description" ""
			(at 147.32 48.26 0)
			(effects
				(font
					(size 1.27 1.27)
				)
			)
		)
		(pin "1"
			(uuid "bb8491da-2825-4a37-bbcf-8a419786aa3a")
		)
		(instances
			(project ""
				(path "/344cfa04-e666-4c5f-9953-672189c8ae7e"
					(reference "#PWR01")
					(unit 1)
				)
			)
		)
	)
	(sheet_instances
		(path "/"
			(page "1")
		)
	)
	(embedded_fonts no)
)
