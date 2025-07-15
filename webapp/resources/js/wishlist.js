/**
 * 찜 기능 전역 JavaScript
 * 모든 페이지에서 사용 가능한 찜 기능
 */

// 찜 기능 초기화
function initWishlist() {
    updateWishlistCount();
    
    // 찜 버튼 이벤트 리스너 추가
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('wishlist-btn') || 
            e.target.closest('.wishlist-btn')) {
            
            const button = e.target.classList.contains('wishlist-btn') ? 
                          e.target : e.target.closest('.wishlist-btn');
            
            const productId = button.getAttribute('data-product-id');
            if (productId) {
                e.preventDefault();
                toggleWishlist(productId, button);
            }
        }
    });
}

// 찜 토글 함수
function toggleWishlist(productId, buttonElement) {
    // 로그인 체크 (서버에서 체크하지만 클라이언트에서도 확인)
    const loginUser = document.querySelector('.user-link, .welcome-text');
    if (!loginUser || loginUser.textContent.includes('Welcome to M4 Auction')) {
        if (confirm('로그인이 필요한 서비스입니다. 로그인하시겠습니까?')) {
            window.location.href = '/acu/member/luxury-login.jsp';
        }
        return;
    }
    
    const heartIcon = buttonElement.querySelector('i');
    const isCurrentlyWishlisted = heartIcon.classList.contains('fas');
    const action = isCurrentlyWishlisted ? 'remove' : 'add';
    
    // 버튼 비활성화 (중복 클릭 방지)
    buttonElement.style.pointerEvents = 'none';
    
    fetch('/acu/wishlist/wishlistAction.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `action=${action}&productId=${productId}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // 아이콘 변경
            updateWishlistButton(buttonElement, data.isWishlisted);
            
            // 헤더 카운트 업데이트
            updateWishlistCount(data.wishlistCount);
            
            // 성공 메시지 표시 (선택적)
            showWishlistToast(data.message, data.isWishlisted);
            
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error('찜 처리 중 오류:', error);
        alert('오류가 발생했습니다. 다시 시도해주세요.');
    })
    .finally(() => {
        // 버튼 재활성화
        buttonElement.style.pointerEvents = 'auto';
    });
}

// 찜 버튼 상태 업데이트
function updateWishlistButton(buttonElement, isWishlisted) {
    const heartIcon = buttonElement.querySelector('i');
    
    if (isWishlisted) {
        heartIcon.classList.remove('far');
        heartIcon.classList.add('fas');
        heartIcon.style.color = '#dc2626';
        buttonElement.setAttribute('title', '찜 해제');
    } else {
        heartIcon.classList.remove('fas');
        heartIcon.classList.add('far');
        heartIcon.style.color = '';
        buttonElement.setAttribute('title', '찜 추가');
    }
}

// 헤더 찜 카운트 업데이트
function updateWishlistCount(count) {
    const wishlistCountElement = document.getElementById('wishlistCount');
    
    if (count !== undefined) {
        // 서버에서 받은 카운트 사용
        if (wishlistCountElement) {
            wishlistCountElement.textContent = count;
        }
    } else {
        // 서버에서 현재 카운트 조회
        fetch('/acu/wishlist/getWishlistCount.jsp')
        .then(response => response.json())
        .then(data => {
            if (data.success && wishlistCountElement) {
                wishlistCountElement.textContent = data.count;
            }
        })
        .catch(error => {
            console.error('찜 카운트 조회 오류:', error);
        });
    }
}

// 찜 토스트 메시지 표시
function showWishlistToast(message, isWishlisted) {
    // 기존 토스트 제거
    const existingToast = document.querySelector('.wishlist-toast');
    if (existingToast) {
        existingToast.remove();
    }
    
    const toast = document.createElement('div');
    toast.className = 'wishlist-toast';
    toast.innerHTML = `
        <div class="toast-content">
            <i class="fas fa-heart" style="color: ${isWishlisted ? '#dc2626' : '#999'}"></i>
            <span>${message}</span>
        </div>
    `;
    
    // 토스트 스타일
    toast.style.cssText = `
        position: fixed;
        top: 140px;
        right: 20px;
        background: white;
        color: #333;
        padding: 16px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 10000;
        opacity: 0;
        transform: translateX(100%);
        transition: all 0.3s ease;
        border-left: 4px solid ${isWishlisted ? '#dc2626' : '#999'};
    `;
    
    toast.querySelector('.toast-content').style.cssText = `
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        font-weight: 500;
    `;
    
    document.body.appendChild(toast);
    
    // 애니메이션 실행
    setTimeout(() => {
        toast.style.opacity = '1';
        toast.style.transform = 'translateX(0)';
    }, 100);
    
    // 3초 후 자동 제거
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    }, 3000);
}

// 페이지 로드 시 찜 상태 확인 및 버튼 업데이트
function loadWishlistStatus() {
    const wishlistButtons = document.querySelectorAll('.wishlist-btn[data-product-id]');
    
    if (wishlistButtons.length === 0) return;
    
    const productIds = Array.from(wishlistButtons).map(btn => btn.getAttribute('data-product-id'));
    
    fetch('/acu/wishlist/checkWishlistStatus.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'productIds=' + productIds.join(',')
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            wishlistButtons.forEach(button => {
                const productId = button.getAttribute('data-product-id');
                const isWishlisted = data.wishlistStatus[productId] === true;
                updateWishlistButton(button, isWishlisted);
            });
        }
    })
    .catch(error => {
        console.error('찜 상태 확인 오류:', error);
    });
}

// 찜 기능 헬퍼 함수들
const WishlistHelper = {
    // 찜 버튼 HTML 생성
    createWishlistButton: function(productId, className = 'wishlist-btn') {
        return `
            <button class="${className}" data-product-id="${productId}" title="찜 추가">
                <i class="far fa-heart"></i>
            </button>
        `;
    },
    
    // 찜 상태에 따른 스타일 클래스 반환
    getWishlistClass: function(isWishlisted) {
        return isWishlisted ? 'wishlisted' : 'not-wishlisted';
    },
    
    // 찜 개수 포맷팅
    formatWishlistCount: function(count) {
        if (count >= 1000) {
            return Math.floor(count / 1000) + 'k';
        }
        return count.toString();
    }
};

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    initWishlist();
    loadWishlistStatus();
});