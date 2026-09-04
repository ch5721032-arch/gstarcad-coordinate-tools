;; chain-distance.lsp - Cumulative distance along a chain of picked points
;; Command: CHAINDIST
(defun c:CHAINDIST ( / pt prev total seg )
  (setq prev (getpoint "\nFirst point: "))
  (if prev
    (progn
      (setq total 0.0 seg 0)
      (while (setq pt (getpoint prev "\nNext point (Enter to finish): "))
        (setq total (+ total (distance prev pt))
              seg (1+ seg))
        (princ (strcat "\nSegment " (itoa seg) ": "
                       (rtos (distance prev pt) 2 3)))
        (setq prev pt)
      )
      (princ (strcat "\nTotal: " (rtos total 2 3) " units"))
    )
  )
  (princ)
)
