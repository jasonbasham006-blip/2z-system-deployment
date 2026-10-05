(set-logic QF_BV)
(set-option :produce-models true)

(define-fun m1 () (_ BitVec 32) (_ bv17 32))
(define-fun m2 () (_ BitVec 32) (_ bv19 32))
(define-fun m3 () (_ BitVec 32) (_ bv23 32))

(define-fun filter_306  () (_ BitVec 32) (_ bv306 32))
(define-fun filter_923  () (_ BitVec 32) (_ bv923 32))
(define-fun filter_1118 () (_ BitVec 32) (_ bv1118 32))

(declare-const patent_index (_ BitVec 32))
(declare-const r1 (_ BitVec 32))
(declare-const r2 (_ BitVec 32))
(declare-const r3 (_ BitVec 32))

(assert (= r1 (bvurem patent_index m1)))
(assert (= r2 (bvurem patent_index m2)))
(assert (= r3 (bvurem patent_index m3)))

(assert (= (bvand patent_index (_ bv1 32)) (_ bv0 32)))

(define-fun gate_923_pass () Bool
  (= (bvurem patent_index filter_923) (_ bv0 32)))

(define-fun gate_1118_306_pass () Bool
  (not (= (bvand (bvxor patent_index filter_1118) filter_306) (_ bv0 32))))

(assert (or gate_923_pass gate_1118_306_pass))
(assert (bvge patent_index (_ bv100000 32)))
(assert (bvle patent_index (_ bv999999 32)))

(check-sat)
(get-model)
