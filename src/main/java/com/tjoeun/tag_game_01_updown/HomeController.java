package com.tjoeun.tag_game_01_updown;

import java.util.ArrayList;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping("/")
	public String home(HttpServletRequest request, Model model) {
		System.out.println("컨트롤러 home 메소드 실행 => 게임페이지 로딩");
		// 세션 초기화
		HttpSession session = request.getSession();
		session.invalidate();
		
		// 정답 숫자 생성
		Random random = new Random();
		int answer = random.nextInt(100) + 1;
		
		// 뷰페이지로 전달
		model.addAttribute("answer", answer);
		model.addAttribute("chance", 10);
		
		return "home";
	}
	// value = "/hello", method = RequestMethod.GET
	@RequestMapping(value = "/answer", method = RequestMethod.POST)
	public String answer(HttpServletRequest request, Model model) {
		System.out.println("컨트롤러 answer 메소드 실행 => 정답입력 후 로딩");
		int trynum = Integer.parseInt(request.getParameter("trynum"));//입력한 정답
		int answer = Integer.parseInt(request.getParameter("answer"));// 실제 정답
		model.addAttribute("answer", answer);
		int chance = Integer.parseInt(request.getParameter("chance"));// 남은 기회
		HttpSession session = request.getSession(); 
		
		System.out.println(trynum + "===============" + answer + "===========" + chance);
		ArrayList<Integer> prenums = null;
		try {// 입력한 정답 리스트 => 세션 저장
			prenums = (ArrayList<Integer>) session.getAttribute("prenums");
			// 찬스가 남아있고 정답이 아니면서 이전에 추측한 수가 아닐때 추가한다.
			if (chance > 0 && trynum != answer && prenums.indexOf(trynum) < 0) {
				prenums.add(trynum);
			}
			session.setAttribute("prenums", prenums);
		} catch (Exception e) {
			prenums = new ArrayList<Integer>();
			prenums.add(trynum);
			session.setAttribute("prenums", prenums);
		}
		
		if (chance >= 1) { // 시도 횟수가 1 이상이면 게임 진행
			if (trynum == answer) { // 정답
				model.addAttribute("result", "와우~! 당신의 <span class='text-danger bg-success-subtle h4 fw-bold px-3'>승리</span>입니다." );
				model.addAttribute("result2", "정답은 <span class='text-danger h2 fw-bold'>" + answer + "</span> 입니다.");
				model.addAttribute("chance", 0);
				return "home";
			} else if (trynum < answer) { // UP
				model.addAttribute("result", "<span class='text-danger'>Up <i class='bi bi-arrow-up-circle-fill'></i></span> " + (chance - 1) + "번의 기회가 남았습니다...");
				if (chance <= 4) {
					model.addAttribute("result", "<span class='text-danger'>Up <i class='bi bi-arrow-up-circle-fill'></i></span> " + (chance - 1) + "번 남았습니다...<span style='color:white; background-color:crimson;'>집중하세요!</span>");
				}
				int closeup = trynum;
				for (int num:prenums) { // 넘어온 값과 오답 값들을 비교해 최대값을 찾아서 넘겨준다
					if (num < answer) {// 오답값이 정답보다 작을때만
						closeup = num > closeup ? num:closeup;
					}
				}
				session.setAttribute("closeup", closeup);
			} else { // DOWN
				model.addAttribute("result", "<span class='text-primary'>Down <i class='bi bi-arrow-down-circle-fill'></i></span> " + (chance - 1) + "번의 기회가 남았습니다...");
				if (chance <= 4) {
					model.addAttribute("result", "<span class='text-primary'>Down <i class='bi bi-arrow-down-circle-fill'></i></span> <span style='color:white; background-color:crimson;'>" + (chance - 1) + "번 남았습니다...집중하세요!</span>");
				}
				int closedown = trynum;
				for (int num:prenums) { // 넘어온 값과 오답 값들을 비교해 최소값을 찾아서 넘겨준다
					if (num > answer) {// 오답값이 정답보다 클때만
						closedown = num < closedown ? num:closedown;
					}
				}
				session.setAttribute("closedown", closedown);
			}
			model.addAttribute("chance", chance - 1); // 시도횟수 -1
			
			// 패배조건 chance == 1
			if (chance == 1) { // 시도횟수가 1이면
				model.addAttribute("result", "안타깝네요!... 당신의 <span class='text-primary bg-success-subtle h4 fw-bold px-3'>패배</span>입니다.");
				model.addAttribute("result2", "정답은 <span class='text-danger h2 fw-bold'>" + answer + "</span> 입니다.");
				model.addAttribute("chance", chance - 1);
				return "home";
			}
		}
		return "home";
	}
	
	@RequestMapping("/restart")
	public String restart(HttpServletRequest request, Model model) {
		System.out.println("컨트롤러 restart 메소드 실행 => 새로운 게임페이지 로딩");
		//return home(request, model);
		return home(request, model);
	}
}
