<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    String alertMsg = (String)session.getAttribute("alertMsg");
    if(alertMsg != null) {
        session.removeAttribute("alertMsg");
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            min-height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            overflow: hidden;
            width: 100%;
            max-width: 450px;
            position: relative;
        }
        
        .login-header {
            background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%);
            padding: 48px 40px;
            text-align: center;
            color: white;
            position: relative;
        }
        
        .login-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.1;
        }
        
        .logo {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }
        
        .logo-subtitle {
            font-size: 14px;
            opacity: 0.9;
            font-weight: 300;
            letter-spacing: 2px;
            text-transform: uppercase;
            position: relative;
            z-index: 1;
        }
        
        .login-form {
            padding: 48px 40px;
        }
        
        .form-group {
            margin-bottom: 24px;
            position: relative;
        }
        
        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .form-input {
            width: 100%;
            padding: 16px 20px;
            font-size: 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            background: #f9fafb;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #1a1a1a;
            background: white;
            box-shadow: 0 0 0 3px rgba(26, 26, 26, 0.1);
        }
        
        .form-input::placeholder {
            color: #9ca3af;
        }
        
        .login-button {
            width: 100%;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            border: none;
            padding: 18px;
            font-size: 16px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 32px;
            position: relative;
            overflow: hidden;
        }
        
        .login-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(201, 150, 26, 0.3), transparent);
            transition: left 0.6s ease;
        }
        
        .login-button:hover::before {
            left: 100%;
        }
        
        .login-button:hover {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        
        .login-links {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            padding-top: 24px;
            border-top: 1px solid #f3f4f6;
        }
        
        .login-link {
            color: #6b7280;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.3s ease;
            position: relative;
        }
        
        .login-link:hover {
            color: #1a1a1a;
        }
        
        .login-link::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 1px;
            background: #c9961a;
            transition: width 0.3s ease;
        }
        
        .login-link:hover::after {
            width: 100%;
        }
        
        .alert {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 24px;
            font-size: 14px;
            text-align: center;
        }
        
        .back-to-home {
            position: absolute;
            top: 20px;
            left: 20px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: color 0.3s ease;
            z-index: 10;
        }
        
        .back-to-home:hover {
            color: white;
        }
        
        /* 반응형 */
        @media (max-width: 480px) {
            .login-container {
                margin: 10px;
            }
            
            .login-header {
                padding: 32px 24px;
            }
            
            .login-form {
                padding: 32px 24px;
            }
            
            .logo {
                font-size: 28px;
            }
            
            .login-links {
                flex-direction: column;
                gap: 12px;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <a href="<%=ctx%>/index.jsp" class="back-to-home">
        <i class="fas fa-arrow-left"></i>
        메인으로 돌아가기
    </a>
    
    <div class="login-container">
        <div class="login-header">
            <div class="logo">M4 Auction</div>
            <div class="logo-subtitle">Luxury Art Gallery</div>
        </div>
        
        <form class="login-form" action="<%=ctx%>/member/loginAction.jsp" method="post">
            <% if(alertMsg != null) { %>
            <div class="alert">
                <%=alertMsg%>
            </div>
            <% } %>
            
            <div class="form-group">
                <label class="form-label">아이디</label>
                <input type="text" 
                       id="userId" 
                       name="userId" 
                       class="form-input"
                       placeholder="아이디를 입력하세요"
                       required>
            </div>
            
            <div class="form-group">
                <label class="form-label">비밀번호</label>
                <input type="password" 
                       id="userPwd" 
                       name="userPwd" 
                       class="form-input"
                       placeholder="비밀번호를 입력하세요"
                       required>
            </div>
            
            <button type="submit" class="login-button">
                <i class="fas fa-sign-in-alt"></i>
                로그인
            </button>
            
            <div class="login-links">
                <a href="enroll_step1.jsp" class="login-link">
                    <i class="fas fa-user-plus"></i>
                    회원가입
                </a>
                <a href="findIdPwForm.jsp" class="login-link">
                    <i class="fas fa-key"></i>
                    아이디/비밀번호 찾기
                </a>
            </div>
        </form>
    </div>
    
    <script>
        // 폼 검증
        document.querySelector('.login-form').addEventListener('submit', function(e) {
            const userId = document.getElementById('userId').value.trim();
            const userPwd = document.getElementById('userPwd').value.trim();
            
            if (!userId) {
                alert('아이디를 입력해주세요.');
                document.getElementById('userId').focus();
                e.preventDefault();
                return false;
            }
            
            if (!userPwd) {
                alert('비밀번호를 입력해주세요.');
                document.getElementById('userPwd').focus();
                e.preventDefault();
                return false;
            }
        });
        
        // 입력 필드 포커스 효과
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('focused');
            });
        });
    </script>
</body>
</html>