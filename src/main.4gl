IMPORT util
IMPORT os
IMPORT FGL fgldialog

MAIN
  DEFINE l_wc, l_permission, l_result STRING
	DEFINE l_qty INT
	DEFINE l_arr DYNAMIC ARRAY OF RECORD
		code STRING,
		qty INT
	END RECORD

  IF ui.Interface.getFrontEndName() = "GMA" THEN
    LET l_permission = "android.permission.CAMERA"
    CALL ui.Interface.frontCall("android", "askForPermission", [l_permission], [l_result])
    DISPLAY "Permission:", l_permission, " Result:", l_result
    LET l_permission = "android.permission.WRITE_EXTERNAL_STORAGE"
    CALL ui.Interface.frontCall("android", "askForPermission", [l_permission], [l_result])
    DISPLAY "Permission:", l_permission, " Result:", l_result
  END IF

  OPEN FORM f FROM "form"
  DISPLAY FORM f

	DIALOG  ATTRIBUTES(UNBUFFERED)
		INPUT BY NAME l_wc, l_qty
			BEFORE INPUT
				IF ui.Interface.getFrontEndName() != "GMA" THEN
					CALL DIALOG.setActionActive("scanner", FALSE)
					CALL DIALOG.setActionActive("scanner2", FALSE)
					CALL ui.window.getCurrent().getForm().setElementHidden("scanner", TRUE)
					CALL ui.window.getCurrent().getForm().setElementHidden("scanner2", TRUE)
				END IF

			ON CHANGE l_wc
				DISPLAY "Changed:", l_wc
				DISPLAY SFMT("Change: %1", l_wc) TO results

			AFTER FIELD l_qty
				DISPLAY "After Field qty"
				NEXT FIELD l_wc

			ON ACTION ACCEPT
				DISPLAY "accept"
				IF l_qty IS NOT NULL AND l_qty > 0 AND l_result IS NOT NULL THEN
					LET l_arr[ l_arr.getLength() + 1].code = l_result
					LET l_arr[ l_arr.getLength() ].qty = l_qty
					LET l_result = NULL
					LET l_qty = 0
				END IF
				NEXT FIELD l_wc

		END INPUT
		DISPLAY ARRAY l_arr TO scrarr.*
		END DISPLAY

		ON ACTION scanned
			DISPLAY "Scanned:", l_wc
			LET l_result = l_wc
			DISPLAY SFMT("Scanned: %1", l_wc) TO results
			NEXT FIELD l_qty

		ON ACTION scanner
			CALL scanner()

		ON ACTION scanner2
			CALL scanner2()

		ON ACTION close
			EXIT DIALOG
	END DIALOG

END MAIN
----------------------------------------------------------------------------------------------------
-- Default Mobile Barcode Scanner
FUNCTION scanner()
  DEFINE l_code, l_type STRING
  CALL ui.Interface.frontCall("mobile", "scanBarCode", [], [l_code, l_type])
  DISPLAY SFMT("FC: Code: %1 Type: %2", l_code, l_type) TO results
END FUNCTION
----------------------------------------------------------------------------------------------------
-- Cordova Barcode Scanner
FUNCTION scanner2()
  DEFINE l_options RECORD
    preferFrontCamera BOOLEAN,
    showFlipCameraButton BOOLEAN,
    showTorchButton BOOLEAN,
    disableAnimations BOOLEAN,
    disableSuccessBeep BOOLEAN,
    formats STRING
  END RECORD
  DEFINE l_result STRING

	LET l_options.showTorchButton = TRUE
	LET l_options.showFlipCameraButton = TRUE
	LET l_options.formats = "PDF_417,DATA_MATRIX"
	CALL ui.Interface.frontCall("cordova", "call", ["BarcodeScanner", "scan", l_options], [l_result])
	CALL fgldialog.fgl_winMessage("Result", l_result, "info")
	DISPLAY "result:", l_result
  DISPLAY SFMT("FC: Result: %1", l_result) TO results
END FUNCTION
----------------------------------------------------------------------------------------------------