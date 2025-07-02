// File: src/main/java/com/auction/common/PageInfo.java
// 역할: 페이징 처리에 필요한 모든 정보를 계산하고 담는 객체입니다.
package com.auction.common;

public class PageInfo {
    
    private int listCount;      // 현재 총 게시글 개수
    private int currentPage;    // 현재 페이지 (사용자가 요청한 페이지)
    private int pageLimit;      // 하단에 보여질 페이징 바의 페이지 최대 개수
    private int boardLimit;     // 한 페이지에 보여질 게시글의 최대 개수
    private int maxPage;        // 전체 페이지들 중에서의 가장 마지막 페이지
    private int startPage;      // 하단에 보여질 페이징 바의 시작 수
    private int endPage;        // 하단에 보여질 페이징 바의 끝 수
    
    // 기본 생성자
    public PageInfo() {}
    
    // 모든 정보를 계산해주는 매개변수 있는 생성자  -- 페이징// 삭제예정
    public PageInfo(int listCount, int currentPage, int pageLimit, int boardLimit) {
        this.listCount = listCount;
        this.currentPage = currentPage;
        this.pageLimit = pageLimit;
        this.boardLimit = boardLimit;
        
        // * maxPage : 총 페이지 수
        // listCount와 boardLimit에 영향을 받는다.
        // ex) 게시글이 101개면? 11페이지가 필요하다. (100개 / 10개 = 10페이지, 나머지 1개를 위해 1페이지 추가)
        // (int)((double)listCount / boardLimit + 0.9) 와 같은 방식도 가능
        this.maxPage = (int)Math.ceil((double)listCount / boardLimit);
        
        // * startPage : 페이징 바의 시작 수
        // pageLimit, currentPage에 영향을 받는다.
        // ex) pageLimit이 10일 때, 1, 11, 21, 31, ...
        this.startPage = (currentPage - 1) / pageLimit * pageLimit + 1;
        
        // * endPage : 페이징 바의 끝 수
        // startPage, pageLimit에 영향을 받는다.
        this.endPage = startPage + pageLimit - 1;
        
        // startPage가 11이라서 endPage가 20으로 계산되었는데,
        // maxPage가 13이라면? endPage는 13이 되어야 한다.
        if(this.endPage > this.maxPage) {
            this.endPage = this.maxPage;
        }
    }

    // Getters and Setters
    public int getListCount() {
        return listCount;
    }

    public void setListCount(int listCount) {
        this.listCount = listCount;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getPageLimit() {
        return pageLimit;
    }

    public void setPageLimit(int pageLimit) {
        this.pageLimit = pageLimit;
    }

    public int getBoardLimit() {
        return boardLimit;
    }

    public void setBoardLimit(int boardLimit) {
        this.boardLimit = boardLimit;
    }

    public int getMaxPage() {
        return maxPage;
    }

    public void setMaxPage(int maxPage) {
        this.maxPage = maxPage;
    }

    public int getStartPage() {
        return startPage;
    }

    public void setStartPage(int startPage) {
        this.startPage = startPage;
    }

    public int getEndPage() {
        return endPage;
    }

    public void setEndPage(int endPage) {
        this.endPage = endPage;
    }

    @Override
    public String toString() {
        return "PageInfo [listCount=" + listCount + ", currentPage=" + currentPage + ", pageLimit=" + pageLimit
                + ", boardLimit=" + boardLimit + ", maxPage=" + maxPage + ", startPage=" + startPage + ", endPage="
                + endPage + "]";
    }
}
