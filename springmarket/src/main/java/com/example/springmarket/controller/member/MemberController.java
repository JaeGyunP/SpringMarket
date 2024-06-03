package com.example.springmarket.controller.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.springmarket.model.email.EmailDTO;

import com.example.springmarket.model.email.EmailFindPwd;

import com.example.springmarket.model.email.EmailService;

import com.example.springmarket.model.member.MemberDAO;
import com.example.springmarket.model.member.MemberDTO;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {
	@Autowired
	MemberDAO memberDao;

	@GetMapping("member/pagelogin.do")
	public ModelAndView login() {
		return new ModelAndView("member/login");
	}

	@GetMapping("member/pagejoin.do")
	public ModelAndView join() {
		return new ModelAndView("member/join");
	}

	@PostMapping("member/login.do")
	public ModelAndView login_check(@RequestParam(name = "userid") String userid,
			@RequestParam(name = "passwd") String passwd, HttpSession session) {
		String pass = memberDao.encrypt(passwd);
		String nickname = memberDao.login(userid, pass);
		String message = "";
		String url = "";
		if (nickname == null) { // 로그인 실패
			message = "error";
			url = "member/login";
			Map<String, Object> map = new HashMap<>();
			map.put("message", message);
			return new ModelAndView(url, "map", map);
		}else {
			int report_code = memberDao.loginCheck(userid,pass);
			System.out.println(report_code);
			if(report_code == 1){
			message = "report";
			url = "member/login";
			Map<String, Object> map = new HashMap<>();
			map.put("message", message);
			return new ModelAndView(url, "map", map);
		}else {
			message = nickname + "님 환영합니다.";
			
			// 세션변수 등록
			session.setAttribute("userid", userid);
			session.setAttribute("nickname", nickname);
			
			return new ModelAndView("redirect:/");
		}
	}
		
	}

	@GetMapping("member/logout.do")
	public String logout(HttpSession session) {
		session.invalidate(); // 세션 초기화
		return "redirect:/member/pagelogin.do";
	}

	@PostMapping("member/join.do")
	public String join(@RequestParam(name = "userid") String userid, @RequestParam(name = "passwd") String passwd,
			@RequestParam(name = "name") String name, @RequestParam(name = "nickname") String nickname,
			@RequestParam(name = "birth") int birth, @RequestParam(name = "phone") String phone,
			@RequestParam(name = "email") String email, @RequestParam(name = "address1") String address1,
			@RequestParam(name = "address2") String address2) {
		String address = address1 + address2;
		String pass = memberDao.encrypt(passwd);
		MemberDTO dto = new MemberDTO();
		dto.setUserid(userid);
		dto.setPasswd(pass);
		dto.setName(name);
		dto.setNickname(nickname);
		dto.setBirth(birth);
		dto.setPhone(phone);
		dto.setEmail(email);
		dto.setAddress(address);
		memberDao.join(dto); // document 저장

		String senderName = "가지나라"; // replace with actual sender name
		String senderMail = "rhwls159@naver.com";

		EmailDTO edto = new EmailDTO();
		edto.setSenderName(senderName);
		edto.setSenderName(senderMail);
		edto.setEmail(email);
		EmailService service = new EmailService();
		try {
			service.mailSender(edto);
			return "redirect:/member/pagelogin.do";

		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/member/pagejoin.do";

		}

	}

	@GetMapping("member/pagefindId.do")
	public ModelAndView pagefindId() {
		return new ModelAndView("member/findid");
	}

	@GetMapping("member/pagefindPwd.do")
	public ModelAndView pagefindPwd() {
		return new ModelAndView("member/findpwd");
	}

	// 비밀번호 변경 메소드로 변경
	@PostMapping("member/findPwd.do")
	public ModelAndView changePwd(@RequestParam(name = "userid") String userid) {
		// TODO: 비밀번호 변경 로직 수행
		String pwd = memberDao.encrypt("a12345");
		System.out.println(pwd);
		memberDao.findPwd(userid, pwd);
		String email = memberDao.email(userid);

		String senderName = "가지나라"; // replace with actual sender name
		String senderMail = "rhwls159@naver.com";

		EmailDTO edto = new EmailDTO();
		edto.setSenderName(senderName);
		edto.setSenderName(senderMail);
		edto.setEmail(email);
		EmailFindPwd findpwd = new EmailFindPwd();
		try {
			findpwd.mailSender2(edto);
			String url = "";
			url = "member/login";
			String message = "이메일이 전송되었습니다.";
			// JavaScript 코드를 포함한 문자열 생성
			String alertScript = "<script>alert('" + message + "');</script>";
			// ModelAndView 객체 생성 시 HTML에 전달할 데이터를 설정
			ModelAndView modelAndView = new ModelAndView(url);
			modelAndView.addObject("alertScript", alertScript);
			return modelAndView;

		} catch (Exception e) {
			String url = "";
			url = "member/findid";
			String message = "없는 아이디 입니다.";
			// JavaScript 코드를 포함한 문자열 생성
			String alertScript = "<script>alert('" + message + "');</script>";
			// ModelAndView 객체 생성 시 HTML에 전달할 데이터를 설정
			ModelAndView modelAndView = new ModelAndView(url);
			modelAndView.addObject("alertScript", alertScript);
			return modelAndView;
		}
	}

	// RESTful API 엔드포인트로 변경
	@PostMapping("member/findId.do")
	public ResponseEntity<Map<String, Object>> findId(@RequestParam(name = "name") String name,
			@RequestParam(name = "birth") String birth, @RequestParam(name = "phone") String phone) {
		String userid = memberDao.findId(name, birth, phone);
		String message = "";
		String url = "";
		if (userid == null) {
			message = "로그인 정보가 정확하지 않습니다.";
			url = "/member/pagefindId.do";
		} else {
			message = "당신의 아이디는 " + userid + "입니다.";
			url = "/member/pagelogin.do";
		}
		Map<String, Object> map = new HashMap<>();
		map.put("message", message);
		map.put("url", url);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	@PostMapping("member/check.do")
	public ResponseEntity<Map<String, String>> check(@RequestParam(name = "userid") String userid) {
		String count = "";
		if (userid == "") {
			count = "false";
		} else {

			count = memberDao.check(userid);
			if (count == null) {
				count = "true"; // count가 null이면 "true" 문자열로 설정
			}
		}
		System.out.println(count);
		Map<String, String> response = new HashMap<>();
		response.put("count", count);

		return ResponseEntity.ok(response);
	}

	@PostMapping("member/emailcheck.do")
	   public ResponseEntity<Map<String, String>> emailcheck(@RequestParam(name = "email") String email) {
	      // TODO: 비밀번호 변경 로직 수행

	      String count1 = "";
	      if (email == "") {
	         count1 = "false";
	      } else {

	         count1 = memberDao.emailcheck(email);
	         if (count1 == null) {
	            count1 = "true"; // count가 null이면 "true" 문자열로 설정
	         }
	      }
	      System.out.println(count1);
	      Map<String, String> response = new HashMap<>();
	      response.put("count1", count1);

	      return ResponseEntity.ok(response);
	   }


	@PostMapping("member/emailcheck_mypage.do")
	public ResponseEntity<Map<String, String>> emailcheck_mypage(@RequestParam(name = "email") String email) {
		String message = "";
		String check = memberDao.emailcheck(email);
		if (check != null) {
			message = "중복된 이메일입니다.";
		} else {
			message = "사용 가능한 이메일 입니다.";
		}
		Map<String, String> response = new HashMap<>();
		System.out.println(message);
		response.put("message", message);
		return ResponseEntity.ok(response);
		
	}
	
	@PostMapping("member/nicknamecheck.do")
	public ResponseEntity<Map<String, String>> nicknamecheck(@RequestParam(name = "nickname") String nickname) {
		String message = "";
		String check = memberDao.nicknamecheck(nickname);
		if (check != null) {
			message = "중복된 닉네임입니다.";
		} else {
			message = "사용 가능한 닉네임 입니다.";
		}
		Map<String, String> response = new HashMap<>();
		System.out.println(message);
		response.put("message", message);
		return ResponseEntity.ok(response);
	}
	
	

	@GetMapping("member/mypage.do")
	public ModelAndView mypage(@RequestParam(name = "userid") String userid) {
		MemberDTO dto = memberDao.mypage(userid);
		return new ModelAndView("member/mypage", "dto", dto);
	}

	@GetMapping("member/mypage_new.do/{userid}")
	public ModelAndView mypage_updatedo(@PathVariable(name = "userid") String userid) {
		MemberDTO dto = memberDao.mypage(userid);
		return new ModelAndView("member/mypage", "dto", dto);
	}

	@PostMapping("member/mypage_update.do")
	public ModelAndView mypage_update(HttpSession session,
			@RequestParam(name = "name") String name, @RequestParam(name = "nickname") String nickname,
			@RequestParam(name = "birth") int birth, @RequestParam(name = "phone") String phone,
			@RequestParam(name = "email") String email, @RequestParam(name = "address1") String address1,
			@RequestParam(name = "address2") String address2) {
		String userid = (String) session.getAttribute("userid");
		System.out.println(userid);
		MemberDTO dto = new MemberDTO();
		dto.setUserid(userid);
		dto.setName(name);
		dto.setNickname(nickname);
		dto.setBirth(birth);
		dto.setPhone(phone);
		dto.setEmail(email);
		dto.setAddress(address1 + address2);
		session.setAttribute("nickname", nickname);
		memberDao.updateMypage(dto);
		System.out.println(dto);
		return new ModelAndView("redirect:/member/mypage_new.do/" + userid);
	}

	@GetMapping("member/detail_passwd.do")
	public ModelAndView detail_passwd() {
		return new ModelAndView("member/change_passwd");
	}

	@GetMapping("member/pageclose.do")
	public ModelAndView pageclose() {
		return new ModelAndView("member/passwdclose");
	}

	@PostMapping("member/changepasswd.do")
	public ModelAndView findPwd(@RequestParam(name = "userid") String userid,
			@RequestParam(name = "passwd1") String passwd1, @RequestParam(name = "passwd2") String passwd2) {
		String url = "";
		String passwd3 = memberDao.encrypt(passwd1);
		String passwd4 = memberDao.encrypt(passwd2);
		String mypasswd = memberDao.mypasswd(userid);
		if (mypasswd.equals(passwd3)) {
			memberDao.findPwd(userid, passwd4);
			url = "member/passwdclose";
			String message = "변경되었습니다.";
			// JavaScript 코드를 포함한 문자열 생성
			String alertScript = "<script>alert('" + message + "');+window.close();</script>";
			// ModelAndView 객체 생성 시 HTML에 전달할 데이터를 설정
			ModelAndView modelAndView = new ModelAndView(url);
			modelAndView.addObject("alertScript", alertScript);
			return modelAndView;

		} else {
			url = "member/change_passwd";
			String message = "기존 비밀번호가 틀렸습니다.";
			// JavaScript 코드를 포함한 문자열 생성
			String alertScript = "<script>alert('" + message + "');</script>";
			// ModelAndView 객체 생성 시 HTML에 전달할 데이터를 설정
			ModelAndView modelAndView = new ModelAndView(url);
			modelAndView.addObject("alertScript", alertScript);
			modelAndView.addObject("userid", userid);
			return modelAndView;
		}

	}

	@GetMapping("member/info.do")
	public ModelAndView info() {
		List<Object> dto = memberDao.info();
		return new ModelAndView("admin/admin_info", "dto", dto);
	}

	@GetMapping("member/updateReport.do")
	public String updateReport(@RequestParam(name = "userid") String userid,
			@RequestParam(name = "report_code") int report_code) {
		MemberDTO dto = new MemberDTO();
		dto.setUserid(userid);
		dto.setReport_code(report_code);
		memberDao.updateReport(dto);

		return "redirect:/member/info.do";
	}

}
