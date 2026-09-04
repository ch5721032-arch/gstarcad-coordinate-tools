;; export-points.lsp - Export picked point coordinates to a CSV file
;; Command: EXPORTPTS
;; Usage: APPLOAD -> EXPORTPTS -> pick points -> Enter to finish
(defun c:EXPORTPTS ( / out f n pt )
  (setq out (getfiled "Save Point CSV" "" "csv" 1))
  (if out
    (progn
      (setq f (open out "w")
            n 0)
      (princ "X,Y,Z\n" f)
      (while (setq pt (getpoint "\nPick point (Enter to finish): "))
        (princ (strcat (rtos (car pt) 2 6) ","
                       (rtos (cadr pt) 2 6) ","
                       (rtos (caddr pt) 2 6) "\n") f)
        (setq n (1+ n))
      )
      (close f)
      (princ (strcat "\nExported " (itoa n) " points to " out))
    )
  )
  (princ)
)
