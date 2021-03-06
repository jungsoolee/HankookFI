-- FAX ���� ��� ����
SELECT  SEND_TYPE = 'F', M.EMP_NO, U.USER_NAME, M.JOB_TIME,
		 ACC_NO = (CASE WHEN M.PRD_NO = '' THEN M.ACC_NO
	  				    ELSE (CASE WHEN M.BLC_NO = '' THEN M.ACC_NO + '-' + M.PRD_NO
								  ELSE M.ACC_NO + '-' + M.PRD_NO + '-' + M.BLC_NO
							  END)
				   END), A.ACC_NAME_KOR,
	     F.RCV_NAME_KOR, F.MEDIA_NO, 
	     R.REPORT_CODE, R.VIEW_FILENAME
FROM SZMAIN_INS M JOIN SZACBIF_INS A
ON M.DEPT_CODE = A.DEPT_CODE
AND M.ACC_NO = A.ACC_NO
JOIN SZFAXDE_INS F
ON M.DEPT_CODE = F.DEPT_CODE
AND M.ACC_NO = F.ACC_NO
JOIN SZREPIF_INS R
ON M.REPORT_CODE = R.REPORT_CODE
LEFT OUTER JOIN SUUSER_TBL U
ON M.DEPT_CODE = U.DEPT_CODE
AND M.EMP_NO = U.USER_ID
WHERE M.DEPT_CODE = '10'
AND M.JOB_DATE = '20180202'