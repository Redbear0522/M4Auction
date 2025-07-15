<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        session.setAttribute("alertMsg", "로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(ctx + "/member/loginForm.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 등록 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            padding-top: 120px !important;
            line-height: 1.6;
        }
        
        .enroll-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .enroll-header {
            text-align: center;
            margin-bottom: 48px;
        }
        
        .enroll-title {
            font-family: 'Playfair Display', serif;
            font-size: 42px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 12px;
        }
        
        .enroll-subtitle {
            color: #6b7280;
            font-size: 18px;
            margin: 0 0 24px 0;
        }
        
        .approval-notice {
            background: #fef3c7;
            border: 2px solid #fbbf24;
            color: #92400e;
            padding: 16px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            max-width: 400px;
            margin: 0 auto;
        }
        
        .approval-notice i {
            font-size: 16px;
        }
        
        .enroll-form {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            padding: 48px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.05);
        }
        
        .form-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f3f4f6;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .section-title i {
            color: #c9961a;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .form-label.required::after {
            content: ' *';
            color: #dc2626;
        }
        
        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: 16px 20px;
            font-size: 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            background: #f9fafb;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        
        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: #1a1a1a;
            background: white;
            box-shadow: 0 0 0 3px rgba(26, 26, 26, 0.1);
        }
        
        .form-textarea {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }
        
        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
            cursor: pointer;
            background: #f9fafb;
            border: 2px dashed #d1d5db;
            border-radius: 8px;
            padding: 32px 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .file-input-wrapper:hover {
            border-color: #1a1a1a;
            background: #f3f4f6;
        }
        
        .file-input {
            position: absolute;
            left: -9999px;
        }
        
        .file-input-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }
        
        .file-input-icon {
            font-size: 32px;
            color: #9ca3af;
        }
        
        .file-input-text {
            color: #6b7280;
            font-weight: 500;
        }
        
        .file-input-hint {
            font-size: 12px;
            color: #9ca3af;
        }
        
        .price-hint {
            font-size: 12px;
            color: #6b7280;
            margin-top: 4px;
            font-style: italic;
        }
        
        .submit-section {
            margin-top: 48px;
            padding-top: 32px;
            border-top: 2px solid #f3f4f6;
        }
        
        .submit-button {
            width: 100%;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            border: none;
            padding: 20px;
            font-size: 18px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .submit-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(201, 150, 26, 0.3), transparent);
            transition: left 0.6s ease;
        }
        
        .submit-button:hover::before {
            left: 100%;
        }
        
        .submit-button:hover {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        
        .alert {
            background: #fef2f2;
            border: 2px solid #fecaca;
            color: #dc2626;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 32px;
            font-size: 14px;
            text-align: center;
        }
        
        /* 이미지 미리보기 스타일 */
        .image-preview {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            background: #f8f9fa;
            border: 2px solid #16a34a;
            border-radius: 8px;
        }
        
        .image-preview img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid #e5e7eb;
        }
        
        .preview-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .preview-filename {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
        }
        
        .remove-image {
            background: #dc2626;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s;
            align-self: flex-start;
        }
        
        .remove-image:hover {
            background: #b91c1c;
        }
        
        .file-input-wrapper.has-image {
            cursor: default;
        }
        
        .file-input-wrapper.has-image .file-input-content {
            display: none;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            body {
                padding-top: 100px !important;
            }
            
            .enroll-container {
                padding: 20px 16px;
            }
            
            .enroll-form {
                padding: 32px 24px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .enroll-title {
                font-size: 32px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="enroll-container">
        <div class="enroll-header">
            <h1 class="enroll-title">상품 등록</h1>
            <p class="enroll-subtitle">고급 예술 작품을 경매에 등록하세요</p>
            <div class="approval-notice">
                <i class="fas fa-info-circle"></i>
                등록된 상품은 관리자 검토 후 경매에 등록됩니다
            </div>
        </div>
        
        <% if(session.getAttribute("alertMsg") != null) { %>
        <div class="alert">
            <%= session.getAttribute("alertMsg") %>
            <% session.removeAttribute("alertMsg"); %>
        </div>
        <% } %>
        
        <form class="enroll-form" action="productEnrollAction.jsp" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            <!-- 작품 정보 -->
            <div class="form-section">
                <h3 class="section-title">
                    <i class="fas fa-palette"></i>
                    작품 정보
                </h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">작품명</label>
                        <input type="text" 
                               id="productName" 
                               name="productName" 
                               class="form-input"
                               placeholder="작품의 제목을 입력하세요"
                               required>
                    </div>
                    <div class="form-group">
                        <label class="form-label required">작가명</label>
                        <input type="text" 
                               id="artistName" 
                               name="artistName" 
                               class="form-input"
                               placeholder="작가의 이름을 입력하세요"
                               required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label required">카테고리</label>
                    <select name="category" id="category" class="form-select" required>
                        <option value="" disabled selected>카테고리를 선택하세요</option>
                        <option value="회화">회화</option>
                        <option value="조각">조각</option>
                        <option value="판화">판화</option>
                        <option value="사진">사진</option>
                        <option value="추상화">추상화</option>
                        <option value="고미술">고미술</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label required">작품 설명</label>
                    <textarea id="productDesc" 
                              name="productDesc" 
                              class="form-textarea"
                              placeholder="작품에 대한 상세한 설명을 입력하세요 (재료, 크기, 제작년도, 특징 등)"
                              required></textarea>
                </div>
            </div>
            
            <!-- 경매 정보 -->
            <div class="form-section">
                <h3 class="section-title">
                    <i class="fas fa-gavel"></i>
                    경매 정보
                </h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">경매 시작가</label>
                        <input type="number" 
                               id="startPrice" 
                               name="startPrice" 
                               class="form-input"
                               min="1000" 
                               step="1000"
                               placeholder="10000"
                               required>
                        <div class="price-hint">최소 1,000원 이상 (1,000원 단위)</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">즉시 구매가 (선택사항)</label>
                        <input type="number" 
                               id="buyNowPrice" 
                               name="buyNowPrice" 
                               class="form-input"
                               min="1000" 
                               step="1000"
                               placeholder="50000">
                        <div class="price-hint">미입력 시 즉시 구매 불가</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label required">경매 마감일시</label>
                    <input type="datetime-local" 
                           id="endTime" 
                           name="endTime" 
                           class="form-input"
                           required>
                </div>
            </div>
            
            <!-- 이미지 업로드 -->
            <div class="form-section">
                <h3 class="section-title">
                    <i class="fas fa-image"></i>
                    작품 이미지
                </h3>
                
                <div class="form-group">
                    <label class="form-label required">작품 사진</label>
                    <div class="file-input-wrapper" onclick="document.getElementById('productImage').click()">
                        <input type="file" 
                               id="productImage" 
                               name="productImage" 
                               class="file-input"
                               accept="image/*" 
                               onchange="previewImage(this)"
                               required>
                        <div class="file-input-content" id="fileInputContent">
                            <i class="fas fa-cloud-upload-alt file-input-icon"></i>
                            <div class="file-input-text">이미지 파일을 선택하세요</div>
                            <div class="file-input-hint">JPG, PNG, GIF (최대 10MB)</div>
                        </div>
                        <div class="image-preview" id="imagePreview" style="display: none;">
                            <img id="previewImg" src="" alt="미리보기">
                            <div class="preview-info">
                                <div class="preview-filename" id="previewFilename"></div>
                                <button type="button" class="remove-image" onclick="removeImage()">
                                    <i class="fas fa-times"></i> 제거
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 제출 버튼 -->
            <div class="submit-section">
                <button type="submit" class="submit-button">
                    <i class="fas fa-plus-circle"></i>
                    상품 등록하기
                </button>
            </div>
        </form>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        // 이미지 미리보기 함수
        function previewImage(input) {
            const wrapper = input.closest('.file-input-wrapper');
            const fileInputContent = document.getElementById('fileInputContent');
            const imagePreview = document.getElementById('imagePreview');
            const previewImg = document.getElementById('previewImg');
            const previewFilename = document.getElementById('previewFilename');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                // 파일 크기 체크 (10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('파일 크기는 10MB 이하여야 합니다.');
                    input.value = '';
                    return;
                }
                
                // 이미지 파일 체크
                if (!file.type.startsWith('image/')) {
                    alert('이미지 파일만 업로드 가능합니다.');
                    input.value = '';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    previewFilename.textContent = file.name;
                    
                    // UI 업데이트
                    fileInputContent.style.display = 'none';
                    imagePreview.style.display = 'flex';
                    wrapper.classList.add('has-image');
                    wrapper.style.borderColor = '#16a34a';
                    wrapper.style.background = '#f0fdf4';
                };
                reader.readAsDataURL(file);
            }
        }
        
        // 이미지 제거 함수
        function removeImage() {
            const input = document.getElementById('productImage');
            const wrapper = input.closest('.file-input-wrapper');
            const fileInputContent = document.getElementById('fileInputContent');
            const imagePreview = document.getElementById('imagePreview');
            
            // 파일 입력 초기화
            input.value = '';
            
            // UI 복원
            fileInputContent.style.display = 'block';
            imagePreview.style.display = 'none';
            wrapper.classList.remove('has-image');
            wrapper.style.borderColor = '#d1d5db';
            wrapper.style.background = '#f9fafb';
        }
        
        // 폼 검증
        function validateForm() {
            const startPrice = parseInt(document.getElementById('startPrice').value);
            const buyNowPrice = parseInt(document.getElementById('buyNowPrice').value) || 0;
            const endTime = new Date(document.getElementById('endTime').value);
            const now = new Date();
            
            // 시작가 검증
            if (startPrice < 1000) {
                alert('시작가는 최소 1,000원 이상이어야 합니다.');
                return false;
            }
            
            // 즉시구매가 검증
            if (buyNowPrice > 0 && buyNowPrice <= startPrice) {
                alert('즉시구매가는 시작가보다 높아야 합니다.');
                return false;
            }
            
            // 마감일 검증
            if (endTime <= now) {
                alert('경매 마감일은 현재 시간보다 늦어야 합니다.');
                return false;
            }
            
            // 최소 1시간 후 마감 권장
            const oneHourLater = new Date(now.getTime() + 60 * 60 * 1000);
            if (endTime < oneHourLater) {
                if (!confirm('경매 기간이 1시간 미만입니다. 계속 진행하시겠습니까?')) {
                    return false;
                }
            }
            
            return true;
        }
        
        // 최소 마감일시 설정 (현재 시간)
        document.addEventListener('DOMContentLoaded', function() {
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            document.getElementById('endTime').min = now.toISOString().slice(0, 16);
        });
    </script>
</body>
</html>