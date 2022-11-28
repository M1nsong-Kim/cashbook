package dao;

import java.sql.*;
import java.util.ArrayList;
import util.DBUtil;
import vo.Category;

public class CategoryDao {
	
	// 관리자: updateCategoryAction.jsp
	public int updateCategoryName(Category category) throws Exception{
		int row = 0;
		String sql = "UPDATE category \r\n"
				+ "SET category_name = ?, updatedate = CURDATE() \r\n"
				+ "WHERE category_no = ?";
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, category.getCategoryName());
		stmt.setInt(2, category.getCategoryNo());
		row = stmt.executeUpdate();
		dbUtil.close(null, stmt, conn);
		return row;
	}
	
	// 관리자: updateCategoryForm.jsp
	public Category selectCategoryOne(int categoryNo) throws Exception{
		Category category = null;	// null로 줄지 생성자 사용해서 빈 데이터로 줄지 선택해야(보편적인 건 null)
		String sql = "SELECT category_no categoryNo, category_name categoryName FROM category WHERE category_no = ?";
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, categoryNo);
		rs = stmt.executeQuery();
		if(rs.next()) {
			category = new Category();
			category.setCategoryNo(rs.getInt("categoryNo"));
			category.setCategoryName(rs.getString("categoryName"));
		}
		dbUtil.close(rs, stmt, conn);
		return category;
	}
	
	// 관리자: 카테고리 삭제
	public int deleteCategory(int categoryNo) throws Exception{
		int row = 0;
		String sql = "DELETE FROM category WHERE category_no = ?";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, categoryNo);
		row = stmt.executeUpdate();	// 성공 == 1
		
		dbUtil.close(null, stmt, conn);
		return row;
	}
	
	// 관리자: 카테고리 추가
	public int insertCategory(Category category) throws Exception{
		int row = 0;
		String sql = "INSERT INTO category(\r\n"
				+ "		category_kind\r\n"
				+ "		,	category_name\r\n"
				+ "		, updatedate\r\n"
				+ "		, createdate)\r\n"
				+ "VALUES(\r\n"
				+ "		?\r\n"
				+ "		, ?\r\n"
				+ "		, CURDATE()\r\n"
				+ "		, CURDATE())";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, category.getCategoryKind());
		stmt.setString(2, category.getCategoryName());
		row = stmt.executeUpdate();
		
		dbUtil.close(null, stmt, conn);
		return row;
	}
	
	// 관리자: 카테고리 목록 for 카테고리 관리
	public ArrayList<Category> selectCategoryListByAdmin() throws Exception{
		ArrayList<Category> list = new ArrayList<>();
		String sql = "SELECT category_no categoryNo, category_kind categoryKind, category_name categoryName, updatedate, createdate FROM category ORDER BY category_kind";

		DBUtil dbUtil = new DBUtil();
		
		// db 자원(jdbc api 자원) 초기화
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		rs = stmt.executeQuery();	// ResultSet은 테이블(뷰) 사실 select는 rs 생성 안 하고 stmt.executeUpdate();해도 됨
		
		while(rs.next()) {
			Category c = new Category();
			c.setCategoryNo(rs.getInt("categoryNo"));	// rs.getInt(1);(셀렉트절 순서)도 가능하지만 가독성이 떨어진다
			c.setCategoryKind(rs.getString("categoryKind"));
			c.setCategoryName(rs.getString("categoryName"));
			c.setUpdatedate(rs.getString("updatedate"));	// db날짜 타입이지만 자바단에서 문자열 타입으로 받는다
			c.setCreatedate(rs.getString("createdate"));
			list.add(c);
		}
		
		// db 자원(jdbc api 자원) 반납
		dbUtil.close(rs, stmt, conn);
		return list;
	}

	// 다 출력하면 돼서 입력값x
	public ArrayList<Category> selectCategoryList() throws Exception{
		ArrayList<Category> categoryList = new ArrayList<Category>();
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT category_no categoryNo, category_kind categoryKind, category_name categoryName FROM category ORDER BY category_kind";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Category c = new Category();
			c.setCategoryNo(rs.getInt("categoryNo"));
			c.setCategoryKind(rs.getString("categoryKind"));
			c.setCategoryName(rs.getString("categoryName"));
			categoryList.add(c);
		}
		return categoryList;
	}

}
