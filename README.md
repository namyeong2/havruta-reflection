# 하브루타 성찰

하브루타 대화 뒤 학생이 6개 문항으로 성찰을 남기는 모바일 우선 웹앱입니다. 학생은 학번만 입력하며, 이름·이메일·전화번호는 수집하지 않습니다.

## 현재 상태

- `index.html`은 브라우저에서 바로 열어 볼 수 있는 UI 프로토타입입니다.
- 현재 저장소는 브라우저 로컬 저장소를 사용합니다. 실제 수업에서 여러 학생의 답변을 모으려면 Supabase 연결이 필요합니다.
- `supabase/schema.sql`에는 학생은 제출만 하고, 로그인한 교사만 조회·삭제할 수 있도록 하는 테이블과 RLS 정책이 들어 있습니다.

## Supabase 설정 순서

1. Supabase에서 새 프로젝트를 만듭니다.
2. SQL Editor에서 [`supabase/schema.sql`](supabase/schema.sql)를 실행합니다.
3. Authentication에서 교사 계정을 만들고, [`supabase/teacher-role.sql`](supabase/teacher-role.sql)의 이메일을 교사 이메일로 바꿔 실행합니다. 이 계정에만 `{"role":"teacher"}` 권한이 부여됩니다.
4. Project Settings > API의 Project URL과 anon key를 앱 설정에 연결합니다. anon key는 공개 클라이언트 키이며, service role key는 절대 브라우저나 Git에 넣지 않습니다.
5. 앱의 저장소 구현을 Supabase repository로 교체하고, 교사 화면은 Supabase Auth 로그인으로 변경합니다.

## 배포 전 확인

- 학교의 개인정보 보유 기간을 정하고, 교사 화면에서 정기적으로 CSV 백업·삭제합니다.
- 시작 화면에 “학번은 수업 성찰 확인 용도로만 사용됩니다”라는 고지를 유지합니다.
- 실제 교사 인증을 붙이기 전에는 교사 화면을 공개 배포하지 않습니다. HTML에 들어간 비밀번호는 보안 장치가 아닙니다.
